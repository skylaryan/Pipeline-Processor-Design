module cpu(input clk, rst_n, output hlt, output [15:0] pc_out);
	wire [3:0] opcode, rd, rs, rt;
	wire [7:0] u;
	wire [2:0] cond;
	wire reg_write_en;
	wire exmem_flush, idex_flush, ifid_flush, memwb_flush, final_enable;
	// PC Controls
	wire [15:0] updated_PC, read_PC, calcPC, defaultPC, zeroed_pc, exmemPC, memwbPC, exmem_calcPC;
	// Register File
	wire [15:0] default_alu_in1, alu_rs, alu_rt, alu_out, test;
	// Memory
	wire [15:0] inst_data;
	wire mem_enable, mem_write;
	wire [15:0] mem_data;
	// flag register
	wire [2:0] read_flag;
	wire write_flag_en, flush, stall, ifid_write_en, flush_in;

	assign ifid_write_en = (flush_in) ? 0 : (stall) ? 0 : 1;
	// Program Counter
	wire Write_PC_reg;
	//CACHE SIGNALS
	wire [15:0] i_memory_address, i_data_in, d_data_in, d_memory_address;	// change this back to mem_data
	wire i_mem_enable, i_mem_data_valid, i_filling_cache, i_miss_detected, cache_mem_write, d_mem_data_valid, d_mem_wr, d_mem_enable, d_filling_cache, d_miss_detected ;	// change this back to mem_enable
	
	assign Write_PC_reg = ~stall & ~i_filling_cache & ~d_filling_cache & ~i_miss_detected & ~d_miss_detected;
	Register program_counter(.clk(clk), .rst(~rst_n), .D(updated_PC), .WriteReg(Write_PC_reg),
				 .ReadEnable1(1'b1), .ReadEnable2(), .Bitline1(read_PC), .Bitline2());
	assign pc_out = read_PC;
	wire valid, init_enable, first; //, start_pipe; STALL PIPE VAR
	counter valid_counter(.clk(clk), .rst(~rst_n), .valid(valid), .enable(init_enable), .first(first)); //, .pipe(pipe));

	//default PC incrementer
	add_sub16b pc_incr(.A(pc_out), .B(16'h0002), .sub(1'b0), .mem_op(1'b0), .result(defaultPC), .ovfl());
	wire stop;
	assign stop = ((inst_data[15:12] == 16'b1111 & ~(flush | flush_in)) ? 1 : 0); //UNCOMMENT FOR FLUSH
	assign zeroed_pc = (rst_n) ? defaultPC : 16'h0000;
	//PC select
	assign updated_PC = ~stop ? ((~valid) ? zeroed_pc:
		(flush_in) ?  calcPC : defaultPC) : read_PC; //  UNCOMMENT FOR FLUSH

	/// CACHE ********************************************************* \\\
	wire [15:0] idex_pc;
	// instruction memory
	// cache signals
	wire [15:0] mem_out;
	cache instruction_cache(.clk(clk), .rst_n(rst_n), .address(pc_out), .mem_data(mem_out), .mem_data_valid(i_mem_data_valid), 
				.memory_address(i_memory_address), .instruction(inst_data),
			   		.mem_enable(i_mem_enable), .mem_wr(), .filling_cache(i_filling_cache), .miss_detected(i_miss_detected));
	//memory1c inst_memory(.data_out(inst_data), .data_in(), .addr(pc_out), .enable(~stall), .wr(1'b0), .clk(clk), .rst(~rst_n));
	//memory4c memory(.data_out(i_mem_data), .data_in(), .addr(memory_address), .enable(filling_cache & i_mem_enable), .wr(1'b0), .clk(clk), .rst(~rst_n), .data_valid(mem_data_valid));

	wire [15:0] exmem_SrcData2;
	wire [15:0] alu_out_p3;
	assign d_data_in = (d_mem_data_valid & d_filling_cache) ? mem_out : exmem_SrcData2;
	wire cache_mem_valid;
	assign cache_mem_valid = mem_enable & valid;
	dcache data_cache(.clk(clk), .rst_n(rst_n), .address(alu_out_p3), .data_in(d_data_in), .enable(cache_mem_valid), .write(cache_mem_write), .mem_data_valid(d_mem_data_valid), 
			.mem_wr(mem_write), .memory_address(d_memory_address), .data_out(mem_data), 
				.filling_cache(d_filling_cache), .miss_detected(d_miss_detected));

	cache_controller controller(.clk(clk), .rst_n(rst_n), .i_mem_en(i_mem_enable), .d_mem_en(cache_mem_valid), .i_miss_detected(i_miss_detected), .d_miss_detected(d_miss_detected), .d_mem_wr(mem_write), .i_filling_cache(i_filling_cache), .d_filling_cache(d_filling_cache),
			.i_address(i_memory_address), .d_address(d_memory_address), 
				.d_data_in(d_data_in), .mem_out(mem_out), .i_mem_data_valid(i_mem_data_valid), .d_mem_data_valid(d_mem_data_valid));

	//memory1c data_memory(.data_out(mem_data), .data_in(exmem_SrcData2), .addr(alu_out_p3), .enable(mem_enable), .wr(mem_write), .clk(clk), .rst(~rst_n));

	/// *************************************************************** \\\

	wire stall_in;
	wire [15:0] ifid_pc;
	wire [2:0] ifid_nvz;
	
	dff halt_ff(.clk(clk), .rst(~rst_n), .d(stop | finished), .q(finished), .wen(1'b1));

	dff flush_ff(.clk(clk), .rst(~rst_n), .d(flush_in), .q(flush), .wen(1'b1));
	
	wire[15:0] ifid_inst_data, idex_inst_data, exmem_inst_data, memwb_inst_data;
	wire[3:0] rd1, rd2, rd3, rd4, rs1, rs2, rs3, rs4, rt1, rt2, rt3, rt4, opcode1, opcode2, opcode3, opcode4;
	wire[3:0] ifid_rd, idex_rd, exmem_rd, memwb_rd;
	wire[3:0] ifid_rs, idex_rs;
	wire[3:0] ifid_rt, idex_rt, memwb_rt;
	wire[7:0] idex_u;
	wire[3:0] ifid_opcode, idex_opcode, exmem_opcode, memwb_opcode;
	wire[2:0] idex_cond; 
	wire ifid_reg_write_en, idex_reg_write_en, exmem_reg_write_en, memwb_reg_write_en; 
	wire[2:0] ifid_cyclops, idex_cyclops, exmem_cyclops, memwb_cyclops;
	wire [3:0] dst_branch, empty_reg, destp1, destp2, destp3, destp4, src1p1, src1p2, src1p3, src1p4, src2p1, src2p2, src2p3, src2p4;
	
	wire rst_flag;
	//previous reset
	dff rst_ff(.clk(clk), .rst(~rst_n), .d(rst_n), .q(rst_flag), .wen(1'b1));

	// 
	// most recent inst
	// the instruction in fetch stage is the instruction in the program counter 
	instruction_fetch if_id(.instruction(ifid_inst_data), .rd(ifid_rd), .rs(ifid_rs), .rt(ifid_rt), .u(), .opcode(ifid_opcode), .cond(), 
				.cyclops(ifid_cyclops), .write_en(ifid_reg_write_en), .rst_prev(rst_flag));
	// 2nd most
	//the instruction in decode stage is the instruction is the output of the fetch stage 
	instruction_fetch id_ex(.instruction(idex_inst_data), .rd(idex_rd), .rs(idex_rs), .rt(idex_rt), .u(idex_u), .opcode(idex_opcode), .cond(idex_cond), 
				.cyclops(idex_cyclops), .write_en(idex_reg_write_en), .rst_prev(rst_flag));
	instruction_fetch ex_mem(.instruction(exmem_inst_data), .rd(exmem_rd), .rs(), .rt(), .u(), .opcode(exmem_opcode), .cond(), 
				.cyclops(exmem_cyclops), .write_en(exmem_reg_write_en), .rst_prev(rst_flag));
	instruction_fetch mem_wb(.instruction(memwb_inst_data), .rd(memwb_rd), .rs(), .rt(memwb_rt), .u(), .opcode(memwb_opcode), 
				.cond(), .cyclops(memwb_cyclops), .write_en(memwb_reg_write_en), .rst_prev(rst_flag));

	// IF/ID PIPE 1 
	wire ifid_stall, miss_or_stall, miss;
	assign stall = (rst_n) ? (stall_in) : 0;
	assign miss_or_stall = (i_miss_detected | d_miss_detected | i_filling_cache | d_filling_cache) ? 0 : (stall) ? 0 : 1;
	assign miss = ~(i_miss_detected | d_miss_detected | i_filling_cache | d_filling_cache);
	
	wire stall_ifid_reset;
	dff stall_reset(.clk(clk), .rst(~rst_n), .d(stall_in & ~(i_filling_cache | i_miss_detected)), .q(stall_ifid_reset), .wen(1'b1));
	
	ifid ifid_pipe(.clk(clk), .flush(flush_in), .rst(~rst_n | stall_ifid_reset), .write(miss_or_stall), .ifid_nvz(ifid_nvz), .inst_data(inst_data), .pc(updated_PC), 
		.inst_data_pl(ifid_inst_data), .pc_pl(ifid_pc), .ifid_flush(ifid_flush));
	
	//wire stall_intermediate;
	//assign stall_intermediate = (i_filling_cache | d_filling_cache) ? (0) : (stall_in);
	hazard_unit hazard_unit(.ifid_rs(ifid_rs), .ifid_rt(ifid_rt), .idex_rt(idex_rt), .idex_cyclops(idex_cyclops), .stall(stall_in));
	

	// register file
	wire [3:0] DstReg, SrcReg2;
	wire [15:0] DstData, SrcData1, SrcData2;
	assign DstReg = (memwb_opcode == 4'b1000) ? memwb_rt : memwb_rd;	//lw redirect
	assign SrcReg2 = (ifid_opcode[3:1] == 3'b101) ? ifid_rd : ifid_rt;

	//writeback reg mux from last pipeline
	wire [15:0] mem_out_p4,  alu_out_p4, alu_in2, alu_in1;
	assign DstData = (memwb_opcode == 4'b1000) ? mem_out_p4 : alu_out_p4;

	RegisterFile register_file(.clk(clk), .rst(~rst_n), .SrcReg1(ifid_rs), .SrcReg2(SrcReg2), .DstReg(DstReg),
				   .WriteReg(final_enable), .DstData(DstData), .SrcData1(SrcData1), .SrcData2(SrcData2));


	//ID/EX PIPE 2
	wire idex_stall;
	wire [15:0]idex_SrcData1, idex_SrcData2, SrcData1_fwd, SrcData2_fwd;
	wire [2:0] idex_nvz;
	
	assign SrcData1_fwd = ((memwb_reg_write_en) & (memwb_rd != 0) & (memwb_rd == ifid_rs)) ? DstData : SrcData1;
	assign SrcData2_fwd = ((memwb_reg_write_en) & (memwb_rd != 0) & (memwb_rd == ifid_rt)) ? DstData : SrcData2;

	idex idex_pipe(.clk(clk), .rst(~rst_n), .flush(flush_in), .write(miss), .idex_nvz(idex_nvz), .inst_data(ifid_inst_data), .pc(ifid_pc), .SrcData1(SrcData1_fwd), .SrcData2(SrcData2_fwd), .stall_in(stall | ~rst_n), .ifid_flush(ifid_flush),
		.stall_out(idex_stall), .inst_data_pl(idex_inst_data), .pc_pl(idex_pc), .SrcData1_pl(idex_SrcData1), .SrcData2_pl(idex_SrcData2), .flush_out(idex_flush), .flush_out2(piped_ifid_flush));


	// flag register
	wire readZ, readV, readN, setZ, setV, setN;
	dff z_flag (.q(readZ), .d(setZ), .wen(write_flag_en), .clk(clk), .rst(~rst_n));
	dff v_flag (.q(readV), .d(setV), .wen(write_flag_en), .clk(clk), .rst(~rst_n));
	dff n_flag (.q(readN), .d(setN), .wen(write_flag_en), .clk(clk), .rst(~rst_n));
	assign read_flag[2:0] = {readN, readV, readZ};	//used in pc_control

	// Forwarding Unit
	wire [1:0] forwardA, forwardB;
	forwarding_unit forwarding(.exmem_rd(exmem_rd), .memwb_rd(memwb_rd), .idex_rs(idex_rs), .idex_rt(idex_rt), .exmem_reg_write_en(exmem_reg_write_en), .memwb_reg_write_en(memwb_reg_write_en), .forwardA(forwardA), .forwardB(forwardB));

	// ALU

	assign default_alu_in1 = (idex_opcode == 4'b1110) ? idex_pc : idex_SrcData1;

	// forwardA = 00 - no forwarding
	// forwardA = 10 - from prior alu (ex->ex)
	// forwardA = 01 - from memwb
	//assign alu_in1 = (forwardA == 2'b10) ? alu_out_p3 : ((forwardA == 2'b01) ?  DstData : default_alu_in1);
	assign alu_in1 = (~flush_in) ? ((forwardA == 2'b10) ? alu_out_p3 : ((forwardA == 2'b01) ?  DstData : default_alu_in1)) : default_alu_in1;
	// forwardB = 00
	// forwardB = 10
	// forwardB = 01
	 // changed alu_out_4 to DstData because it needs to take the mem of the reg if load is selected
	//assign alu_in2 = (forwardB == 2'b10) ? alu_out_p3 : ((forwardB == 2'b01) ?  DstData : idex_SrcData2);	//Maybe DstData <- alu_out_p4
	assign alu_in2 = (~flush_in) ? ((forwardB == 2'b10) ? alu_out_p3 : ((forwardB == 2'b01) ?  DstData : idex_SrcData2)) : idex_SrcData2;

	ALU alu(.opcode(idex_opcode), .offset(idex_u[3:0]), .u(idex_u), .alu_in1(alu_in1), .alu_in2(alu_in2), .alu_out(alu_out),
		 .n_in(readN), .v_in(readV), .z_in(readZ), .write_flag_en(write_flag_en), .n(setN), .v(setV), .z(setZ), .rst_n(rst_n));

	// pc control
	wire [8:0] immediate;
	assign immediate = {idex_rd[0], idex_u[7:0]};  //{rd[0], u}
	assign test = (idex_opcode == 4'b1100) ? exmemPC : idex_pc;
	PC_control pc_control(.opcode(idex_opcode), .C(idex_cond), .It(immediate), .F(read_flag), .alu_rs(idex_SrcData1), .PC_in(test),
		 .PC_out(calcPC), .flush(flush_in));
	
	wire [15:0] exmem_SrcData_in;
	assign exmem_SrcData_in = (idex_inst_data[15] & forwardB == 2'b01) ? alu_in2 : idex_SrcData2;

	// EX/MEM PIPE 3
	wire exmem_stall;
	wire [2:0] exmem_nvz;
	exmem exmem_pipe(.clk(clk), .rst(~rst_n), .flush(idex_flush), .write(miss), .nvz(read_flag), .inst_data(idex_inst_data), .alu_out(alu_out), .SrcData(exmem_SrcData_in), .calcPC(calcPC), .idexpc(idex_pc), .stall_in(idex_stall | ~rst_n),
		.stall_out(exmem_stall), .nvz_pl(exmem_nvz), .inst_data_pl(exmem_inst_data), .alu_out_pl(alu_out_p3), .SrcData_pl(exmem_SrcData2), .exmemPC(exmemPC), .exmem_calcPC(exmem_calcPC), .flush_out(exmem_flush));

	// Data_mem
	assign mem_enable = exmem_opcode[3] & ~exmem_opcode[2] & ~exmem_opcode[1];   //opcode[3] & ~opcode[2] & ~opcode[1];
	assign mem_write = (exmem_opcode == 4'b1001) ? 1 : 0;
	//memory1c data_memory(.data_out(mem_data), .data_in(exmem_SrcData2), .addr(alu_out_p3), .enable(mem_enable), .wr(mem_write), .clk(clk), .rst(~rst_n));

	//MEM/WB PIPE 4
	wire [2:0] memwb_nvz;
	wire memwb_stall;
	wire delayed_memwb_flush;
	memwb memwb_pipe(.clk(clk), .rst(~rst_n), .flush(exmem_flush), .write(miss), .nvz(exmem_nvz), .inst_data(exmem_inst_data), .mem_out(mem_data), .alu_out(alu_out_p3), .exmemPC(exmemPC), .stall_in(exmem_stall | ~rst_n),
		.stall_out(memwb_stall), .nvz_pl(memwb_nvz), .inst_data_pl(memwb_inst_data), .mem_out_pl(mem_out_p4), .alu_out_pl(alu_out_p4), .memwbPC(memwbPC), .flush_out(memwb_flush));
	assign reg_write_en = (~memwb_stall) ? (((memwb_opcode[3] == 1'b0) | (memwb_opcode[3:1] == 3'b101) | (memwb_opcode == 4'b1110)) ? (1) : ((memwb_opcode == 4'b1000) ? (1) : (0))) : 0;

	assign final_enable = (init_enable) ? ((memwb_flush | delayed_memwb_flush) ? 0 : reg_write_en) : 0;

	
	dff delayer(.q(delayed_memwb_flush), .d(memwb_flush | ~rst_n), .wen(1), .clk(clk), .rst(~rst_n));
	assign hlt = (memwb_opcode == 4'b1111) ? 1 : 0 ;	//opcode == 1111

endmodule




