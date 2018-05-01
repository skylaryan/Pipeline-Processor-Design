module cla_4b(input [3:0] a, b, input cin, output [3:0] sum, output cout, pg, gg);

	wire [3:0] g, p, c;
	
	assign g = a & b;	// generate
	assign p = a ^ b;

	assign c[0] = cin;
	assign c[1] = g[0] | (p[0] & c[0]);
	assign c[2] = g[1] | (p[1] & g[0]) | (p[0] & p[0] & c[0]);
	assign c[3] = g[2] | (p[2] & g[1]) | (p[2] & p[1] & g[0]) | (p[2] & p[1] & p[0] & c[0]);

	assign cout = g[3] | (p[3] & g[2]) | (p[3] & p[2] & g[1]) | (p[3] & p[2] & p[1] & g[0]) |(p[3] & p[2] & p[1] & p[0] & c[0]);

	assign sum = p ^ c;

	assign pg = p[3] & p[2] & p[1] & p[0];
	assign gg = g[3] | (p[3] & g[2]) | (p[3] & p[2] & g[1]) | (p[3] & p[2] & p[1] & p[0]);
endmodule

module cla_4b_tb();
	

	// Inputs
    reg [3:0] A;
    reg [3:0] B;
    reg Cin;

    // Outputs
    wire [3:0] S;
    wire Cout;
    wire PG;
    wire GG;

    // Instantiate the Unit Under Test (UUT)
    cla_4b uut(
    .a(A), 
    .b(B),
    .cin(Cin),
    .sum(S), 
    .cout(Cout), 
    .pg(PG), 
    .gg(GG)
    );

    initial begin
    // Initialize Inputs
    A = 0;  B = 0;  Cin = 0;
    // Wait 100 ns for global reset to finish
    #100;
        
    // Add stimulus here
    A=4'b0001;B=4'b0000;Cin=1'b0;
    #10 A=4'b100;B=4'b0011;Cin=1'b0;
    #10 A=4'b1101;B=4'b1010;Cin=1'b1;
    #10 A=4'b1110;B=4'b1001;Cin=1'b0;
    #10 A=4'b1111;B=4'b1010;Cin=1'b0;
    end 
 
    initial begin
 $monitor("time=",$time,, "A=%b B=%b Cin=%b : Sum=%b Cout=%b PG=%b GG=%b",A,B,Cin,S,Cout,PG,GG);
    end      
endmodule