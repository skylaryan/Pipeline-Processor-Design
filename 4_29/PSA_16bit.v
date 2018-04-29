module PSA_16bit(Sum,Error,A,B,sub);
input[15:0] A,B; //input values
input sub;
output[15:0] Sum; //sum output
output Error; //To indicate overflows


wire c0, c1, c2;
wire [3:0] Sum1, Sum2, Sum3, Sum4, sat1, sat2, sat3, sat4;
wire OF1, OF2, OF3, OF4;

addsub_4bit first_4bit(.Sum(Sum1), .Ovfl(OF1), .A(A[3:0]), .B(B[3:0]), .sub(sub));

addsub_4bit second_4bit(.Sum(Sum2), .Ovfl(OF2), .A(A[7:4]), .B(B[7:4]), .sub(sub));

addsub_4bit third_4bit(.Sum(Sum3), .Ovfl(OF3), .A(A[11:8]), .B(B[11:8]), .sub(sub));

addsub_4bit last_4bit(.Sum(Sum4), .Ovfl(OF4), .A(A[15:12]), .B(B[15:12]), .sub(sub));

assign Error = OF1 | OF2 | OF3 | OF4;
//assign Sum = {Sum4, Sum3, Sum2, Sum1};
 
assign sat1 = OF1 ? {A[3], {3{~A[3]}}} : Sum1; 
assign sat2 = OF2 ? {A[3], {3{~A[3]}}} : Sum2; 
assign sat3 = OF3 ? {A[3], {3{~A[3]}}} : Sum3; 
assign sat4 = OF4 ? {A[3], {3{~A[3]}}} : Sum4; 

assign Sum = {sat4, sat3, sat2, sat1};


endmodule





