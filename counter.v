module counter(input clk, rst, output valid, enable);

wire [3:0] data_in, data_out;

dff bit0(.q(data_out[0]), .d(data_in[0]), .wen(~enable), .clk(clk), .rst(rst));
dff bit1(.q(data_out[1]), .d(data_in[1]), .wen(~enable), .clk(clk), .rst(rst));
dff bit2(.q(data_out[2]), .d(data_in[2]), .wen(~enable), .clk(clk), .rst(rst));
dff bit3(.q(data_out[3]), .d(data_in[3]), .wen(~enable), .clk(clk), .rst(rst));


addsub_4bit adder(.Sum(data_in), .Ovfl(), .A(data_out), .B(4'h1), .sub(1'b0));

assign valid  = (data_out == 4'b0011 | data_out[3] == 1'b1 | data_out[2] == 1'b1);
assign enable = (data_out == 4'b0100); 

endmodule
