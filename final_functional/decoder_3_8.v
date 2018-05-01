module decoder_3_8(input [2:0] index, output [7:0] onehot_enable);

assign onehot_enable = (index == 3'b000) ? 8'h1:
		  	(index == 3'b001) ? 8'h2:
			(index == 3'b010) ? 8'h4:
			(index == 3'b011) ? 8'h8:
			(index == 3'b100) ? 8'h10:
			(index == 3'b101) ? 8'h20:
			(index == 3'b110) ? 8'h40:
			(index == 3'b111) ? 8'h80:
			8'h0;
endmodule
