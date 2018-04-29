module full_adder_1bit(a, b, c, sum, cout);
	input a, b, c;
	output sum, cout;
	
	assign sum = a ^ b ^ c;

	assign cout = (a & b) | (b & c) | (a & c);
endmodule
