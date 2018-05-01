module ALU(input [3:0] opcode, offset, input [7:0] u, input [15:0] alu_in1, alu_in2, output [15:0] alu_out, input n_in, v_in, z_in, output write_flag_en, n, v, z, input rst_n);

// opcode -> execute instruction
localparam ADD = 4'b0000;
localparam SUB = 4'b0001;
localparam RED = 4'b0010;
localparam XOR = 4'b0011;
localparam SLL = 4'b0100;
localparam SRA = 4'b0101;
localparam ROR = 4'b0110;
localparam PADDSB = 4'b0111;
localparam LW = 4'b1000;
localparam SW = 4'b1001;
localparam LHB = 4'b1010;
localparam LLB = 4'b1011;
localparam BINST = 4'b1100;
localparam BR = 4'b1101;
localparam PCS = 4'b1110;
localparam HLT = 4'b1111;

reg [15:0] out;
assign alu_out = out;

reg [15:0] zero = 16'h0000;

wire [15:0] add_sub_out;
wire add_sub_ovfl;
wire [15:0] ALUsrc1, ALUsrc2;

// if LW/SW instruction and reg[rs] with 0xFFFE
assign ALUsrc1 = (opcode[3]) ? (alu_in1 & 16'hFFFE) : alu_in1;
// choose the correct 2nd input to adder
assign ALUsrc2 = (opcode[3]) ? ({{12{offset[3]}}, offset[3:0]} << 1) : alu_in2;

// adder & LW/SW address calculation
add_sub16b adder(.A(ALUsrc1), .B(ALUsrc2), .sub(sub), .mem_op(opcode[3]), .result(add_sub_out), .ovfl(add_sub_ovfl));

wire [15:0] padd_out, red_out;
assign sub = (opcode == SUB) ? 1 : 0;

// parallel adder
PSA_16bit ps1 (.Sum(padd_out), .Error(), .A(alu_in1), .B(alu_in2), .sub(sub));

// reduction unit
reduction r1 (.a(alu_in1), .b(alu_in2), .out(red_out));

// shifter
wire [15:0] shift_out;
Shifter shifter(.Shift_Out(shift_out), .Shift_In(alu_in1), .Shift_Val(offset), .Mode(opcode[1:0]));

// LHB and LLB
wire [15:0] u16;
//assign u16 = {{8{u[7]}}, u};
assign u16 = {{8{1'b0}}, u};

//assign u16 = (opcode == 1011) ? {{8{~}}, u};
wire [15:0] LHB_out, LLB_out, defined_lower_out, defined_upper_out, zeroed, LLB_final ;

assign zeroed = (~rst_n) ? alu_in1 : out;
//assign defined_upper_out [15:8]= (alu_out[15:8] == 8'bxxxxxxxx) ? alu_in1[15:8] : alu_out[15:8];
//assign defined_lower_out [7:0]= (alu_out[7:0] == 8'bxxxxxxxx) ? alu_in1[7:0] : alu_out[7:0];
assign LLB_out = (alu_in2 & 16'hFF00) | u16;
//assign LLB_final = {~LLB_out[15:8], LLB_out[7:0]};
assign LHB_out = (alu_in2 & 16'h00FF) | (u16 << 8);

always @(*) begin
	case (opcode)
		ADD : begin
			assign out = add_sub_out;
		end
		SUB : assign out = add_sub_out;
		RED : assign out = red_out;
		XOR : assign out = alu_in1 ^ alu_in2;
		SLL : assign out = shift_out; 
		SRA : assign out = shift_out;
		ROR : assign out = shift_out;
		PADDSB : assign out = padd_out;
		// for LW and SW: addr = (Reg[ssss] & 0xFFFE) + (oooo << 1)
		LW : assign out = add_sub_out;
		SW : assign out = add_sub_out;
		// Reg[dddd] = (Reg[dddd] &0x00FF) | (uuuuuuuu << 8)
		LHB : assign out = (~rst_n) ? zeroed : LHB_out;
		//  Reg[dddd] = (Reg[dddd] & 0xFF00) | uuuuuuuu 
		LLB : assign out = (~rst_n) ? zeroed : LLB_out;
	//	BINST :
	//	BR :
		PCS : assign out = alu_in1;
 	//	HLT : 
		default: begin
			// error
			end		
	endcase
end

//flags
assign write_flag_en = ((opcode == 4'b0010) | (opcode == 4'b0111)) ? 0 : ~opcode[3];
assign n = (opcode[3:1] == 3'b000) ? ((alu_out[15]) ? 1 : 0) : n_in;
assign v = (opcode[3:1] == 3'b000) ? ((add_sub_ovfl) ? 1 : 0) : v_in;
assign z = (~opcode[3]) ?  (((opcode == 4'b0010) | (opcode == 4'b0111)) ? z_in : 
			   (alu_out == 4'b0000) ? 1 : 0) : z_in; 

endmodule


