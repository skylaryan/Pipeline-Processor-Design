module add_sub16b(input [15:0] A, B, input sub, mem_op, output [15:0] result, output ovfl); 
	wire [15:0] B_bits, sat_result, C, sum;
	wire sat;
	// assign flip the B bits in case of subtraction
	assign B_bits = sub ? ~B: B;
	
	adder_1bit a0 (A[0], B_bits[0], sub, sum[0], C[1]);
	adder_1bit a1 (A[1], B_bits[1], C[1], sum[1], C[2]);
	adder_1bit a2 (A[2], B_bits[2], C[2], sum[2], C[3]);
	adder_1bit a3 (A[3], B_bits[3], C[3], sum[3], C[4]);
	adder_1bit a4 (A[4], B_bits[4], C[4], sum[4], C[5]);
	adder_1bit a5 (A[5], B_bits[5], C[5], sum[5], C[6]);
	adder_1bit a6 (A[6], B_bits[6], C[6], sum[6], C[7]);
	adder_1bit a7 (A[7], B_bits[7], C[7], sum[7], C[8]);
	adder_1bit a8 (A[8], B_bits[8], C[8], sum[8], C[9]);
	adder_1bit a9 (A[9], B_bits[9], C[9], sum[9], C[10]);
	adder_1bit a10 (A[10], B_bits[10], C[10], sum[10], C[11]);
	adder_1bit a11 (A[11], B_bits[11], C[11], sum[11], C[12]);
	adder_1bit a12 (A[12], B_bits[12], C[12], sum[12], C[13]);
	adder_1bit a13 (A[13], B_bits[13], C[13], sum[13], C[14]);
	adder_1bit a14 (A[14], B_bits[14], C[14], sum[14], C[15]);
	adder_1bit a15 (A[15], B_bits[15], C[15], sum[15], C[0]);

	assign add_ovfl = (A[15] & B[15] & ~sum[15]) | (~A[15] & ~B[15] & sum[15]);
	assign sub_ovfl = (A[15] & ~B[15] & ~sum[15]) | (~A[15] & B[15] & sum[15]);
	assign ovfl = sub ? sub_ovfl : add_ovfl;

	assign sat_result = ovfl ? {A[15], {15{~A[15]}}} : sum;
	assign result = (mem_op) ? sum : sat_result;	
endmodule

module adder_1bit(A, B, Cin, S, Cout);         

input A, B, Cin;

output S, Cout;


assign S = A ^ B ^ Cin;

assign Cout = (A & B) | (B & Cin) | (A & Cin);

endmodule


module add_sub16b_tb();
	reg [15:0] A, B;
	reg sub, mem_op;

	wire [15:0] result;
	wire ovfl;
	
	//instantiate uut
	add_sub16b uut(.A(A), .B(B), .sub(sub), .mem_op(mem_op), .result(result), .ovfl(ovfl));

	initial begin
		mem_op = 1'b0;
		A = 16'h0005;
		B = 16'h0008;
		sub = 1'b0;
		#20
		A = 16'h8000;
		B = 16'h8001;
		sub = 1'b0;
		#20
		A = 16'h7fff;
		B = 16'h8000;
		sub = 1'b1;
		#20;
		A = 16'h7000;
		B = 16'h7000;
		sub = 1'b0;


	end
/*	
	initial begin
		A = 16'h0000;
		B = 16'h0000;
		sub = 1'b0;

		repeat(10) begin
			#20
			A = $random;
			B = $random;
			sub = $random;
		end
	end
*/
endmodule
