module icache_tb();
reg clk, rst_n;
reg [15:0] address, mem_data;

wire mem_enable, mem_wr;
wire[15:0] memory_address, instruction;

reg [7:0] cycle_count;

// instantiate iDUT
cache iDUT(.clk(clk), .rst_n(rst_n), .address(address), .mem_data(mem_data), .instruction(instruction), .memory_address(memory_address), .mem_enable(mem_enable), .mem_wr(mem_wr));

initial begin
	clk = 0;
	cycle_count = 0;
	rst_n = 0;
	mem_data = 16'hb151;
	address = 16'h0000;
	#100;
	rst_n = 1;
	#1280;
	address = 16'h0002;
	mem_data = 16'hf000;
end

always begin
	#20
	clk = ~clk;
end

always@(posedge clk) begin
	cycle_count = cycle_count + 1;
end
endmodule
