module RegisterFile(input clk, input rst, input [3:0] SrcReg1, input [3:0] SrcReg2, input [3:0] DstReg, 
	input WriteReg, input [15:0] DstData, inout [15:0] SrcData1, inout [15:0] SrcData2);

wire [15:0] WriteWord, ReadWord1, ReadWord2, Bitline1, Bitline2;

WriteDecoder_4_16 wd(.RegId(DstReg), .WriteReg(WriteReg), .Wordline(WriteWord));

ReadDecoder_4_16 rd_1(.RegId(SrcReg1), .Wordline(ReadWord1));
ReadDecoder_4_16 rd_2(.RegId(SrcReg2), .Wordline(ReadWord2));

// register r_0 should be hardcoded to 0x0000
Register r_0(.clk(clk), .rst(rst), .D(DstData), .WriteReg(WriteWord[0]), .ReadEnable1(ReadWord1[0]), .ReadEnable2(ReadWord2[0]), .Bitline1(Bitline1), .Bitline2(Bitline2));
Register r_1(.clk(clk), .rst(rst), .D(DstData), .WriteReg(WriteWord[1]), .ReadEnable1(ReadWord1[1]), .ReadEnable2(ReadWord2[1]), .Bitline1(Bitline1), .Bitline2(Bitline2));
Register r_2(.clk(clk), .rst(rst), .D(DstData), .WriteReg(WriteWord[2]), .ReadEnable1(ReadWord1[2]), .ReadEnable2(ReadWord2[2]), .Bitline1(Bitline1), .Bitline2(Bitline2));
Register r_3(.clk(clk), .rst(rst), .D(DstData), .WriteReg(WriteWord[3]), .ReadEnable1(ReadWord1[3]), .ReadEnable2(ReadWord2[3]), .Bitline1(Bitline1), .Bitline2(Bitline2));
Register r_4(.clk(clk), .rst(rst), .D(DstData), .WriteReg(WriteWord[4]), .ReadEnable1(ReadWord1[4]), .ReadEnable2(ReadWord2[4]), .Bitline1(Bitline1), .Bitline2(Bitline2));
Register r_5(.clk(clk), .rst(rst), .D(DstData), .WriteReg(WriteWord[5]), .ReadEnable1(ReadWord1[5]), .ReadEnable2(ReadWord2[5]), .Bitline1(Bitline1), .Bitline2(Bitline2));
Register r_6(.clk(clk), .rst(rst), .D(DstData), .WriteReg(WriteWord[6]), .ReadEnable1(ReadWord1[6]), .ReadEnable2(ReadWord2[6]), .Bitline1(Bitline1), .Bitline2(Bitline2));
Register r_7(.clk(clk), .rst(rst), .D(DstData), .WriteReg(WriteWord[7]), .ReadEnable1(ReadWord1[7]), .ReadEnable2(ReadWord2[7]), .Bitline1(Bitline1), .Bitline2(Bitline2));
Register r_8(.clk(clk), .rst(rst), .D(DstData), .WriteReg(WriteWord[8]), .ReadEnable1(ReadWord1[8]), .ReadEnable2(ReadWord2[8]), .Bitline1(Bitline1), .Bitline2(Bitline2));
Register r_9(.clk(clk), .rst(rst), .D(DstData), .WriteReg(WriteWord[9]), .ReadEnable1(ReadWord1[9]), .ReadEnable2(ReadWord2[9]), .Bitline1(Bitline1), .Bitline2(Bitline2));
Register r_10(.clk(clk), .rst(rst), .D(DstData), .WriteReg(WriteWord[10]), .ReadEnable1(ReadWord1[10]), .ReadEnable2(ReadWord2[10]), .Bitline1(Bitline1), .Bitline2(Bitline2));
Register r_11(.clk(clk), .rst(rst), .D(DstData), .WriteReg(WriteWord[11]), .ReadEnable1(ReadWord1[11]), .ReadEnable2(ReadWord2[11]), .Bitline1(Bitline1), .Bitline2(Bitline2));
Register r_12(.clk(clk), .rst(rst), .D(DstData), .WriteReg(WriteWord[12]), .ReadEnable1(ReadWord1[12]), .ReadEnable2(ReadWord2[12]), .Bitline1(Bitline1), .Bitline2(Bitline2));
Register r_13(.clk(clk), .rst(rst), .D(DstData), .WriteReg(WriteWord[13]), .ReadEnable1(ReadWord1[13]), .ReadEnable2(ReadWord2[13]), .Bitline1(Bitline1), .Bitline2(Bitline2));
Register r_14(.clk(clk), .rst(rst), .D(DstData), .WriteReg(WriteWord[14]), .ReadEnable1(ReadWord1[14]), .ReadEnable2(ReadWord2[14]), .Bitline1(Bitline1), .Bitline2(Bitline2));
Register r_15(.clk(clk), .rst(rst), .D(DstData), .WriteReg(WriteWord[15]), .ReadEnable1(ReadWord1[15]), .ReadEnable2(ReadWord2[15]), .Bitline1(Bitline1), .Bitline2(Bitline2));

assign SrcData1 = (ReadWord1[0]) ? 16'b0000 : Bitline1;
assign SrcData2 = (ReadWord2[0]) ? 16'b0000 : Bitline2;

endmodule

