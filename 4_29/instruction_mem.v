// this module should decode the instruction and send it to registers
module instruction_fetch(input[15:0] instruction, output [3:0] rd, rs, rt, opcode,
		       output [7:0] u, output[2:0] cond, cyclops, output write_en, input rst_prev);


localparam SLL = 4'b0100;
localparam SRA = 4'b0101;
localparam ROR = 4'b0110;
localparam LW = 4'b1000;
localparam SW = 4'b1001;
localparam PADDSB = 4'b0111;
localparam BINST = 4'b1100;
localparam BR = 4'b1101;
localparam PCS = 4'b1110;
localparam HLT = 4'b1111;
reg [2:0] reduced_ops;

assign rd = instruction[11:8];
assign rs = instruction[7:4];
assign rt = ((opcode == 4'b1000 | opcode == 4'b1001)) ? instruction [11:8] : ( (opcode == 4'b1010 | opcode == 4'b1011) ? instruction[11:8] : instruction[3:0]);
//assign rt =  instruction[3:0];
assign u = instruction[7:0];
assign cond = instruction[11:9];

assign opcode = instruction[15:12];

assign write_en = (((opcode[3] == 1'b0) | (opcode[3:1] == 3'b101) | (opcode == 4'b1110)) & (rst_prev)) ? (1) : 
		((opcode == 4'b1000) & (rst_prev)) ? (1) : (0);
assign cyclops = reduced_ops;
always @(*) begin
	casex(opcode)
		(opcode[3:2]) : assign reduced_ops = 3'b000; //ADD, SUB, RED, XOR
		PADDSB :  assign reduced_ops = 3'b000;
		SLL: assign reduced_ops = 3'b001;
		SRA: assign reduced_ops = 3'b001;
		ROR: assign reduced_ops = 3'b001;
		LW : assign reduced_ops = 3'b010;
		SW: assign reduced_ops = 3'b011;
		(4'b10XX) : assign reduced_ops = 3'b100; //LHB, LLB
		BINST : assign reduced_ops = 3'b101;
		BR : assign reduced_ops = 3'b110;
		PCS : assign reduced_ops = 3'b111;
	endcase
end

endmodule
