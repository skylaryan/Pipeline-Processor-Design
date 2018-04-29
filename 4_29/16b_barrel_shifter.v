module Shifter(Shift_Out, Shift_In, Shift_Val, Mode);
input[15:0] Shift_In; 	//victim
input[3:0] Shift_Val; 	//shift amount
input [1:0] Mode; 		//select value
output [15:0] Shift_Out;	//Shifter Value

// intermediates
wire [15:0] ars1, ars2, ars4, ars8; // Arithmetic Right Shifts
wire [15:0] lsl1, lsl2, lsl4, lsl8; // Logical Shift Left
wire [15:0] ror1, ror2, ror4, ror8;

// Arithemetic Right Shift
assign ars1 = Shift_Val[0] ? {Shift_In[15], Shift_In[15:1]}: Shift_In[15:0];
assign ars2 = Shift_Val[1] ? {{2{ars1[15]}}, ars1[15:2]}: ars1[15:0];
assign ars4 = Shift_Val[2] ? {{4{ars2[15]}}, ars2[15:4]}: ars2[15:0];
assign ars8 = Shift_Val[3] ? {{8{ars4[15]}}, ars4[15:8]}: ars4[15:0];

// Logical Shift Left
assign lsl1 = Shift_Val[0] ? {Shift_In[14:0], 1'b0} : Shift_In[15:0];
assign lsl2 = Shift_Val[1] ? {lsl1[13:0], {2{1'b0}}} : lsl1[15:0];
assign lsl4 = Shift_Val[2] ? {lsl2[11:0], {4{1'b0}}} : lsl2[15:0];
assign lsl8 = Shift_Val[3] ? {lsl4[7:0], {8{1'b0}}} : lsl4[15:0];

// Rotate Right
assign ror1 = Shift_Val[0] ? {Shift_In[0], Shift_In[15:1]}: Shift_In[15:0];
assign ror2 = Shift_Val[1] ? {{ror1[1:0]}, ror1[15:2]}: ror1[15:0];
assign ror4 = Shift_Val[2] ? {{ror2[3:0]}, ror2[15:4]}: ror2[15:0];
assign ror8 = Shift_Val[3] ? {{ror4[7:0]}, ror4[15:8]}: ror4[15:0];


// decide whether shifting left or right
assign Shift_Out = (Mode == 2'b00) ? lsl8 : ((Mode == 2'b01) ? ars8 : ror8);

endmodule

