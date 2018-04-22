module count_register8b(input clk, rst, write_en, input[15:0] data_in, output [15:0] data_out);
	dff bit0(.q(data_out[0]), .d(data_in[0]), .wen(write_en), .clk(clk), .rst(rst));
	dff bit1(.q(data_out[1]), .d(data_in[1]), .wen(write_en), .clk(clk), .rst(rst));
	dff bit2(.q(data_out[2]), .d(data_in[2]), .wen(write_en), .clk(clk), .rst(rst));
	dff bit3(.q(data_out[3]), .d(data_in[3]), .wen(write_en), .clk(clk), .rst(rst));
	dff bit4(.q(data_out[4]), .d(data_in[4]), .wen(write_en), .clk(clk), .rst(rst));
	dff bit5(.q(data_out[5]), .d(data_in[5]), .wen(write_en), .clk(clk), .rst(rst));
	dff bit6(.q(data_out[6]), .d(data_in[6]), .wen(write_en), .clk(clk), .rst(rst));
	dff bit7(.q(data_out[7]), .d(data_in[7]), .wen(write_en), .clk(clk), .rst(rst));	
endmodule
