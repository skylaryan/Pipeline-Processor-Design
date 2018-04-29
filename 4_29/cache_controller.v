module cache_controller (clk, rst_n, i_mem_en, d_mem_en, i_miss_detected, d_miss_detected, d_mem_wr, i_address, d_address, d_data_in, mem_out, i_filling_cache, d_filling_cache, i_mem_data_valid, d_mem_data_valid);

localparam IDLE = 2'b00;
localparam DATA = 2'b01;
localparam INST = 2'b10;
localparam WRBK = 2'b11;


input clk, rst_n;
//input from caches
input i_mem_en, d_mem_en, d_mem_wr, d_miss_detected, i_miss_detected, i_filling_cache, d_filling_cache;
input [15:0] i_address, d_address, d_data_in;	//output from cache
//output to caches
output [15:0] mem_out;
output i_mem_data_valid, d_mem_data_valid;
//output to handle conflict
//set i_mem invalid

wire mem_en, mem_data_valid;
wire [15:0] mem_out, mem_in, mem_addr;
wire [1:0] state, next_state, fromIDLE, fromDATA, fromINST, fromWRBK;
//wire mem_sel;
//reg [1:0] state, next_state;
//assign mem_sel = d_mem_en;  //1-d_mem, 0-i_mem
assign mem_en = /*~(state == IDLE) & ~(next_state == IDLE);/*/d_mem_en | i_mem_en;


//assign statew = state;
//assign next_statew = next_state;
dff ff0(.q(state[0]), .d(next_state[0]), .wen(1'b1), .clk(clk), .rst(~rst_n));
dff ff1(.q(state[1]), .d(next_state[1]), .wen(1'b1), .clk(clk), .rst(~rst_n));
//assign next_statew = (rst_n) ? (next_state) : IDLE;
/*
always@(*)begin
	case (statew)
		IDLE: assign next_state = d_mem_en ? (d_mem_wr ? WRBK : DATA) :
 				(i_mem_en) ? INST : IDLE;
		DATA: assign next_state = (d_filling_cache) ? DATA : IDLE;
		INST: assign next_state = (i_filling_cache) ? INST : IDLE;
		WRBK: assign next_state = IDLE;
	endcase
end
*/

assign next_state = (state == IDLE) ? (fromIDLE) :
			(state == DATA) ? (fromDATA) :
			(state == INST) ? (fromINST) :
			//(state == WRBK) ? (fromWRBK) :
			IDLE;

assign fromIDLE = (d_miss_detected) ? DATA :
			(i_miss_detected) ? INST :
			(~i_miss_detected & ~d_miss_detected) ? IDLE : IDLE;
			//(~d_mem_wr) ? WRBK : IDLE;

assign fromDATA = (d_filling_cache | d_miss_detected) ? DATA :IDLE;

assign fromINST = (i_filling_cache | i_miss_detected) ? INST : IDLE;

//assign fromWRBK = IDLE;


//assign next_state = (state == IDLE & d_mem_en) | (state == DATA & d_mem_en) ? (d_mem_wr ? WRBK : ((d_filling_cache & (state == DATA) | (d_filling_cache & (state == IDLE))) ? DATA : IDLE)) : 
	//	((state == IDLE & i_mem_en) | (state == INST & i_mem_en) ? ((i_filling_cache & (state == INST)) | (i_filling_cache & (state == IDLE)) ? INST : IDLE) : IDLE);
//assign tmp2 = IDLE;
//assign next_state = (state == WRBK) ? tmp2 : tmp1; 
wire add2, next_add2, add2_rst;
assign add2_rst = ~rst_n | (next_state == DATA | next_state == INST);
dff add2_en(.q(add2), .d(next_add2), .wen(d_mem_wr), .clk(clk), .rst(add2_rst));
		
assign next_add2 = (state == DATA | ((next_state == IDLE |state == IDLE) & d_mem_wr)) ? ~add2 : 1'b0;

assign mem_addr = (state == IDLE & d_mem_wr) ? ((add2) ? (d_address << 1) + 2 : d_address << 1): //(d_address << 1) + 2 : //
		  (state == DATA) ? (d_address << 1): 
		  (state == INST) ? i_address : (i_miss_detected) ? i_address : (d_miss_detected) ? d_address << 1: 16'h0000 ;


//assign addtwo = (mem_addr == (d_address << 1) + 2) ? 

memory4c memory(.data_out(mem_out), .data_in(d_data_in), .addr(mem_addr), .enable(mem_en), 
	.wr(d_mem_wr & ~d_miss_detected & d_mem_en), .clk(clk), .rst(~rst_n), .data_valid(mem_data_valid));

assign i_mem_data_valid = mem_en & (state == INST) & mem_data_valid;
assign d_mem_data_valid = mem_en & (state == DATA)  & mem_data_valid;

endmodule
