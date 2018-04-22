module decoder_7_128(block_address, block);
input [6:0] block_address;
output [127:0] block;

wire [127:0] shift1, shift2, shift4, shift8, shift16, shift32, shift64;

assign shift1 = (block_address[0]) ? 1 << 1 : 1;
assign shift2 = (block_address[1]) ? shift1 << 2 : shift1;
assign shift4 = (block_address[2]) ? shift2 << 4 : shift2;
assign shift8 = (block_address[3]) ? shift4 << 8 : shift4;
assign shift16 = (block_address[4]) ? shift8 << 16 : shift8;
assign shift32 = (block_address[5]) ? shift16 << 32 : shift16;
assign shift64 = (block_address[6]) ? shift32 << 64 : shift32;

assign block = shift64;

endmodule
