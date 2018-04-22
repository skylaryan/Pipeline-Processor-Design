module decoder_7_128_tb();
reg clk;
reg [6:0] address;
wire [127:0] block;

decoder_7_128 decoder(.block_address(address), .block(block));

initial begin
	clk = 0;
	address = 7'b0000000;
	#40
	address = 7'b0000100;
	#40
	address = 7'b0010000;
	#40
	address = 7'b1111111;
	#40;
end

always begin
	clk = ~clk;
	#20;
end

endmodule