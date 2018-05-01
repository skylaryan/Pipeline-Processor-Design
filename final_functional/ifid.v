module ifid(input clk, flush, rst, write, input[2:0] ifid_nvz, input[15:0] inst_data, pc, output ifid_flush, output [15:0]inst_data_pl, pc_pl);

wire flush_or_rst;
assign flush_or_rst = flush | rst;
register_16b pc_reg(.clk(clk), .rst(rst |flush ), .write_en(write), .data_in(pc), .data_out(pc_pl));
register_16b inst_reg(.clk(clk), .rst(rst |flush), .write_en(write), .data_in(inst_data), .data_out(inst_data_pl));

dff flushff(.q(ifid_flush), .d(flush), .wen(write), .clk(clk), .rst(rst));

endmodule

