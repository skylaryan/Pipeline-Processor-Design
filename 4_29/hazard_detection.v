module hazard_unit(input [3:0] ifid_rt, ifid_rs, idex_rt, input [2:0] idex_cyclops, output stall);

/*
1a. EX/MEM.RegisterRd = ID/EX.RegisterRs
1b. EX/MEM.RegisterRd = ID/EX.RegisterRt
2a. MEM/WB.RegisterRd = ID/EX.RegisterRs
2b. MEM/WB.RegisterRd = ID/EX.RegisterRt
*/
//assign hazard = (exmem_rd == idex_rs | exmem_rd == idex_rt | memwb_rd == idex_rs | memwb_rd == idex_rt) ? 1 : 0;

// if (ID/EX.MemRead and((ID/EX.RegisterRt = IF/ID.RegisterRs) or (ID/EX.RegisterRt = IF/ID.RegisterRt)) then stall
assign stall = (idex_cyclops == 2) ? ((idex_rt == ifid_rs | idex_rt == ifid_rt) ? 1 : 0) : 0; 
//assign stall = (idex_cyclops == 2) ? ((idex_rd == ifid_rs | idex_rd == ifid_rt  & ifid_cyclops != 3) ? 1 : 0) : 0; 

endmodule
