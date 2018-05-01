module addsub_4bit(Sum, Ovfl, A, B, sub);
	input [3:0] A, B; 	//Input values
	input sub; 		// add-sub indicator
	output [3:0] Sum; 	//sum output
	output Ovfl; 		//To indicate overflow

	wire co0, co1, co2, co3;	// intermediate carry outs
	wire [3:0] Boperand;

	assign Boperand = (sub) ? ~B : B;
 	// full_adder_1bit(a, b, c, sum, cout)
	full_adder_1bit FA1(A[0], Boperand[0], sub, Sum[0], co0);
	full_adder_1bit FA2(A[1], Boperand[1], co0, Sum[1], co1);
	full_adder_1bit FA3(A[2], Boperand[2], co1, Sum[2], co2);
	full_adder_1bit FA4(A[3], Boperand[3], co2, Sum[3], co3);

	assign Ovfl = (A[3] & Boperand[3] & ~Sum[3]) | (~A[3] & ~Boperand[3] & Sum[3]);
endmodule