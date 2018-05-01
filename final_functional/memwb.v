module memwb(input clk, rst, flush, write, stall_in, input [2:0] nvz, input [15:0] inst_data, mem_out, alu_out, exmemPC, output stall_out, flush_out, output[2:0] nvz_pl, output [15:0] inst_data_pl, mem_out_pl, alu_out_pl, memwbPC);

register_16b inst_reg(.clk(clk), .rst(rst), .write_en(write), .data_in(inst_data), .data_out(inst_data_pl));
register_16b alu_reg(.clk(clk), .rst(rst), .write_en(write), .data_in(alu_out), .data_out(alu_out_pl));
register_16b mem_reg(.clk(clk), .rst(rst), .write_en(write), .data_in(mem_out), .data_out(mem_out_pl));
register_16b memwbPC_reg(.clk(clk), .rst(rst), .write_en(write), .data_in(exmemPC), .data_out(memwbPC));

dff n(.q(nvz_pl[2]), .d(nvz[2]), .wen(write), .clk(clk), .rst(rst));
dff v(.q(nvz_pl[1]), .d(nvz[1]), .wen(write), .clk(clk), .rst(rst));
dff z(.q(nvz_pl[0]), .d(nvz[0]), .wen(write), .clk(clk), .rst(rst));

dff stall(.q(stall_out), .d(stall_in), .wen(write), .clk(clk), .rst(rst));
dff flushff(.q(flush_out), .d(flush), .wen(write), .clk(clk), .rst(rst));

endmodule
