module register_16b(input clk, rst, write_en, input[15:0] data_in, output [15:0] data_out);
	dff bit0(.q(data_out[0]), .d(data_in[0]), .wen(write_en), .clk(clk), .rst(rst));
	dff bit1(.q(data_out[1]), .d(data_in[1]), .wen(write_en), .clk(clk), .rst(rst));
	dff bit2(.q(data_out[2]), .d(data_in[2]), .wen(write_en), .clk(clk), .rst(rst));
	dff bit3(.q(data_out[3]), .d(data_in[3]), .wen(write_en), .clk(clk), .rst(rst));
	dff bit4(.q(data_out[4]), .d(data_in[4]), .wen(write_en), .clk(clk), .rst(rst));
	dff bit5(.q(data_out[5]), .d(data_in[5]), .wen(write_en), .clk(clk), .rst(rst));
	dff bit6(.q(data_out[6]), .d(data_in[6]), .wen(write_en), .clk(clk), .rst(rst));
	dff bit7(.q(data_out[7]), .d(data_in[7]), .wen(write_en), .clk(clk), .rst(rst));
	dff bit8(.q(data_out[8]), .d(data_in[8]), .wen(write_en), .clk(clk), .rst(rst));
	dff bit9(.q(data_out[9]), .d(data_in[9]), .wen(write_en), .clk(clk), .rst(rst));
	dff bit10(.q(data_out[10]), .d(data_in[10]), .wen(write_en), .clk(clk), .rst(rst));
	dff bit11(.q(data_out[11]), .d(data_in[11]), .wen(write_en), .clk(clk), .rst(rst));
	dff bit12(.q(data_out[12]), .d(data_in[12]), .wen(write_en), .clk(clk), .rst(rst));
	dff bit13(.q(data_out[13]), .d(data_in[13]), .wen(write_en), .clk(clk), .rst(rst));
	dff bit14(.q(data_out[14]), .d(data_in[14]), .wen(write_en), .clk(clk), .rst(rst));
	dff bit15(.q(data_out[15]), .d(data_in[15]), .wen(write_en), .clk(clk), .rst(rst));
	
endmodule
