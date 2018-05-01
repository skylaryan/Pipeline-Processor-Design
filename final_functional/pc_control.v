module PC_control(input [3:0] opcode, input [2:0] C, input[8:0] It, input[2:0] F, input[15:0] alu_rs, input [15:0] PC_in, output[15:0] PC_out, output flush);
	
	wire [15:0] default_increment, intermediate, branch_taken, immediate, jump;
	wire N, Z, V;
	assign N = F[2];
	assign Z = F[0];
	assign V = F[1];
	
	//branch with immediate offset or reg (iiiiiiiii << 1)
	Shifter imm_shifter(.Shift_Out(immediate), .Shift_In({{7{It[8]}},It[8:0]}), .Shift_Val(4'b0001), .Mode(2'b00)); 
	//assign immediate = {{7{It[8]}},It[8:0]} << 1;
	
	//PC + 2
	add_sub16b pc_incr(.A(PC_in), .B(16'h0002), .sub(1'b0), .mem_op(1'b0), .result(default_increment), .ovfl()); 

	//puts it all together
	add_sub16b pc_add_immed(.A(default_increment), .B(immediate), .sub(1'b0), .mem_op(1'b0), .result(branch_taken), .ovfl()); 

	//BR opcode 
	assign jump = (opcode == 4'b1101) ? alu_rs : branch_taken;

	assign intermediate =   (C == 3'b111) 			  ? jump:	//Unconditional
				((C == 3'b110) & (F[1])) 	  ? jump:	//Overflow
				((C == 3'b101) & (F[0] | F[2]))	  ? jump:	//Less Than or Equal
				((C == 3'b100) & ((~F[0] & ~F[2]) | F[0])) ? jump:	//Greater Than or Equal	
				((C == 3'b011) & (F[2]))	  ? jump:	//Less Than
				((C == 3'b010) & (~F[0] & ~F[2])) ? jump:	//Greater Than
				((C == 3'b001) & (F[0]))	  ? jump: 	//Equal
				((C == 3'b000) & (~F[0]))	  ? jump	//Not Equal
				 :default_increment;

	assign PC_out = (opcode == 4'b1111) ? PC_in :
			(opcode == 4'b1110) ? default_increment:
			(opcode[3] & opcode[2]) ? intermediate:
			default_increment;

	assign flush = (opcode == 4'b1100 | opcode == 4'b1101) ? ((intermediate == jump) ? 1 : 0 ) : 0;
	//assign flush = (PC_out == alu_rs) | (PC_out == branch_taken);

endmodule
