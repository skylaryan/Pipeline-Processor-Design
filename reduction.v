module reduction(input [15:0] a, b, output [15:0] out);

wire [3:0] outA, outB, outC, outD, outE, outF, outG;
wire carryA, carryB, carryC, carryD, carryE, carryF, carryG;
wire carryWA, carryWB, carryWC, carryWD, outWA, outWB, outWC, outWD;

//7 4bit adders connected in a tree
cla_4b adder4_1(.a(a[3:0]),   .b(b[3:0]),   .cin(1'b0), .sum(outA), .cout(carryA), .pg(), .gg());
cla_4b adder4_2(.a(a[7:4]),   .b(b[7:4]),   .cin(1'b0), .sum(outB), .cout(carryB), .pg(), .gg());
cla_4b adder4_3(.a(a[11:8]),  .b(b[11:8]),  .cin(1'b0), .sum(outC), .cout(carryC), .pg(), .gg());
cla_4b adder4_4(.a(a[15:12]), .b(b[15:12]), .cin(1'b0), .sum(outD), .cout(carryD), .pg(), .gg());
cla_4b adder4_5(.a(outA), .b(outB), .cin(1'b0), .sum(outE), .cout(carryE), .pg(), .gg());
cla_4b adder4_6(.a(outC), .b(outD), .cin(1'b0), .sum(outF), .cout(carryF), .pg(), .gg());
cla_4b adder4_7(.a(outE), .b(outF), .cin(1'b0), .sum(outG), .cout(carryG), .pg(), .gg());

//Wallace Tree
full_adder_1bit adder1_1(.A(carryE),  .B(carryA),  .Cin(carryB),  .S(outWA), .Cout(carryWA));
full_adder_1bit adder1_2(.A(carryF),  .B(carryC),  .Cin(carryD),  .S(outWB), .Cout(carryWB));
full_adder_1bit adder1_3(.A(outWA),   .B(carryG),  .Cin(outWB),   .S(outWC), .Cout(carryWC));
full_adder_1bit adder1_4(.A(carryWA), .B(carryWB), .Cin(carryWC), .S(outWD), .Cout(carryWD));


//final concatenation
assign out = {{10{carryWD}}, outWD, outWC, outG};

endmodule


