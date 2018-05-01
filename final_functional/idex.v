module idex(input clk, rst, flush, write, stall_in, ifid_flush, input[2:0] idex_nvz, input [15:0] inst_data, pc, SrcData1, SrcData2, output stall_out, flush_out, flush_out2, output [15:0] inst_data_pl, pc_pl, SrcData1_pl, SrcData2_pl);

register_16b inst_reg(.clk(clk), .rst(rst|flush), .write_en(write), .data_in(inst_data), .data_out(inst_data_pl));
register_16b SrcData1_reg(.clk(clk), .rst(rst), .write_en(write), .data_in(SrcData1), .data_out(SrcData1_pl));
register_16b SrcData2_reg(.clk(clk), .rst(rst), .write_en(write), .data_in(SrcData2), .data_out(SrcData2_pl));
register_16b pc_reg(.clk(clk), .rst(rst|flush), .write_en(write), .data_in(pc), .data_out(pc_pl));

dff stall(.q(stall_out), .d(stall_in), .wen(write), .clk(clk), .rst(rst));
dff flushff(.q(flush_out), .d(flush), .wen(write), .clk(clk), .rst(rst));
dff flush2ff(.q(flush_out2), .d(ifid_flush), .wen(write), .clk(clk), .rst(rst));
//dff (.q(nvz_pl[2]), .d(nvz[2]), .wen(write), .clk(clk), .rst(rst));
//dff (.q(nvz_pl[1]), .d(nvz[1]), .wen(write), .clk(clk), .rst(rst));
//dff (.q(nvz_pl[0]), .d(nvz[0]), .wen(write), .clk(clk), .rst(rst));


endmodule
