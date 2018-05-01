module adder_3b(A, B, sum);
input [2:0] A, B;
output [2:0] sum;

wire[2:0] C;

adder_1bit a0 (A[0], B[0], 1'b0, sum[0], C[0]);
adder_1bit a1 (A[1], B[1], C[0], sum[1], C[1]);
adder_1bit a2 (A[2], B[2], C[1], sum[2], C[2]);

endmodule
