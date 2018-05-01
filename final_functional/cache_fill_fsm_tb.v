module cache_fill_fsm_tb();


reg clk, rst_n, miss_detected, memory_data_valid;
reg [15:0] memory_data, miss_address;
reg [15:0] cycle_count;
// instantiate the dut
cache_fill_fsm iDUT(.clk(clk), .rst_n(rst_n), .miss_detected(miss_detected), .memory_data_valid(memory_data_valid), .memory_data(memory_data),
			.miss_address(miss_address), .fsm_busy(fsm_busy), .write_data_array(write_data_array), .memory_address(memory_address));

initial begin
	cycle_count = 0;
	clk = 0;
	rst_n = 0;
	miss_detected = 1;
	//memory_data_valid = 1;
	//memory_data = 16'hdead;
	miss_address = 16'h0100;
	#10;
	rst_n = 1;
	#200;
	miss_address = 16'h0200;
	#1130;
	miss_detected = 0;
	#20
	miss_detected = 1;
end

always begin
	clk = ~clk;
	#20;
end
always@(posedge clk) cycle_count = cycle_count + 1;
endmodule
