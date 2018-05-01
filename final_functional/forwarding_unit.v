module forwarding_unit(input [3:0] exmem_rd, memwb_rd, idex_rs, idex_rt, input exmem_reg_write_en, memwb_reg_write_en, output[1:0] forwardA, forwardB);

assign forwardA = (exmem_reg_write_en & (exmem_rd != 0) & (exmem_rd == idex_rs)) ? 2'b10 : 
			((memwb_reg_write_en) & (memwb_rd != 0) & /*~(exmem_reg_write_en & (exmem_rd !=0) & (exmem_rd != idex_rs)) &*/ (memwb_rd == idex_rs)) ? 2'b01 : 0;

assign forwardB = (exmem_reg_write_en & (exmem_rd != 0) & (exmem_rd == idex_rt)) ? 2'b10 : 
			((memwb_reg_write_en) & (memwb_rd != 0) & /*~(exmem_reg_write_en & (exmem_rd !=0) & (exmem_rd != idex_rt)) &*/ (memwb_rd == idex_rt)) ? 2'b01 : 0;


endmodule
