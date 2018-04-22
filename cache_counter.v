module cache_counter(input clk, rst, output received);

wire [15:0] data_in, data_out;

dff bit0(.q(data_out[0]), .d(data_in[0]), .wen(~received), .clk(clk), .rst(rst));
dff bit1(.q(data_out[1]), .d(data_in[1]), .wen(~received), .clk(clk), .rst(rst));
dff bit2(.q(data_out[2]), .d(data_in[2]), .wen(~received), .clk(clk), .rst(rst));
dff bit3(.q(data_out[3]), .d(data_in[3]), .wen(~received), .clk(clk), .rst(rst));
dff bit4(.q(data_out[4]), .d(data_in[4]), .wen(~received), .clk(clk), .rst(rst));
dff bit5(.q(data_out[5]), .d(data_in[5]), .wen(~received), .clk(clk), .rst(rst));
dff bit6(.q(data_out[6]), .d(data_in[6]), .wen(~received), .clk(clk), .rst(rst));
dff bit7(.q(data_out[7]), .d(data_in[7]), .wen(~received), .clk(clk), .rst(rst));
dff bit8(.q(data_out[8]), .d(data_in[8]), .wen(~received), .clk(clk), .rst(rst));
dff bit9(.q(data_out[9]), .d(data_in[9]), .wen(~received), .clk(clk), .rst(rst));
dff bit10(.q(data_out[10]), .d(data_in[10]), .wen(~received), .clk(clk), .rst(rst));
dff bit11(.q(data_out[11]), .d(data_in[11]), .wen(~received), .clk(clk), .rst(rst));
dff bit12(.q(data_out[12]), .d(data_in[12]), .wen(~received), .clk(clk), .rst(rst));
dff bit13(.q(data_out[13]), .d(data_in[13]), .wen(~received), .clk(clk), .rst(rst));
dff bit14(.q(data_out[14]), .d(data_in[14]), .wen(~received), .clk(clk), .rst(rst));
dff bit15(.q(data_out[15]), .d(data_in[15]), .wen(~received), .clk(clk), .rst(rst));


add_sub16b adder(.result(data_in), .mem_op(0), .ovfl(), .A(data_out), .B(16'h1), .sub(1'b0));
//add_sub16b (A, B, input sub, mem_op, output [15:0] result, output ovfl
assign received = (data_out == 16'h20);

endmodule
