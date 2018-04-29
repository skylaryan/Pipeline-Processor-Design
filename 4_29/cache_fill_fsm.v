module cache_fill_fsm(input clk, rst_n, miss_detected, memory_data_valid, input [15:0] memory_data, miss_address, 
			output fsm_busy, write_data_array, write_tag_array, output [15:0] memory_address, data_address);
localparam IDLE = 1'b0;
localparam WAIT = 1'b1;

wire state, next_state, wen;
wire restart_counter;
// dff to hold state
// State 0: Idle
// State 1: Wait
dff state_flop(.q(state), .d(next_state), .wen(1'b1), .clk(clk), .rst(~rst_n));

// count register
wire [15:0] chunk_count, updated_chunk_count;
register_16b chunks(.clk(clk), .rst(restart_counter), .write_en(state), .data_in(updated_chunk_count), .data_out(chunk_count));
// increment the chunks received every clock cycle we are in the wait state
wire [15:0] inc;
assign inc = (state) ? 16'h0001 : 16'h0000;

add_sub16b chunk_inc(.A(chunk_count), .B(inc), .sub(1'b0), .mem_op(1'b1), .result(updated_chunk_count), .ovfl());

wire [15:0] miss_address_f;
register_16b miss_address_reg(.clk(clk), .rst(~rst_n), .write_en(~state), .data_in(miss_address), .data_out(miss_address_f));

wire [15:0] offset, plus0, plus2, plus4, plus6, plus8, plus10, plus12, plus14;
assign plus0 = 16'h0000;
assign plus2 = 16'h0002;
assign plus4 = 16'h0004;
assign plus6 = 16'h0006;
assign plus8 = 16'h0008;
assign plus10 = 16'h000a;
assign plus12 = 16'h000c;
assign plus14 = 16'h000e;

assign plus0_en = (chunk_count == 0);
assign plus2_en = (chunk_count == 1);
assign plus4_en = (chunk_count == 2);
assign plus6_en = (chunk_count == 3);
assign plus8_en = (chunk_count == 4);
assign plus10_en = (chunk_count == 5);
assign plus12_en = (chunk_count == 6);
assign plus14_en = (chunk_count == 7);	

assign offset = (plus0_en) ? plus0
	      : (plus2_en) ? plus2
	      : (plus4_en) ? plus4
	      : (plus6_en) ? plus6
	      : (plus8_en) ? plus8
	      : (plus10_en) ? plus10
	      : (plus12_en) ? plus12
	      : (plus14_en) ? plus14
	      : plus14;


// memory address = miss_address + offset
add_sub16b mem_addr_calculator(.A(miss_address), .B(offset), .sub(1'b0), .mem_op(1'b1), .result(memory_address), .ovfl());
// data address = memory address - offset_init*4 (ie - 8) //OPTIMIZE THIS LATER
// for shrinking the shit
wire [15:0] reverse_offset;
assign reverse_offset = chunk_count == 8 ? plus6
			: chunk_count == 9 ? plus4
			: chunk_count == 10 ? plus2
			: chunk_count == 11 ? plus0
			: plus8;

add_sub16b data_addr_calculator(.A(memory_address), .B(reverse_offset), .sub(1'b1), .mem_op(1'b1), .result(data_address), .ovfl()); 

// when in the wait stage we grab 8 chunks, it takes 4 clock cycles to grab a chunk
// reset the counter when it reaches 4 * 8 = 32
// then assert the all_received signal
wire all_received;
assign restart_counter = (chunk_count == 11) | ~rst_n;
assign all_received = (state == WAIT) & (chunk_count == 11);
// next state logic
// State 0: Idle
// State 1: Wait
assign next_state = (~rst_n) ? IDLE : ((state == IDLE) ? ((miss_detected) ? (WAIT) : (IDLE))
		  : ((all_received) ? (IDLE) : (WAIT))); 

// while in state 0:	transition on miss_detected
// 0 -> 1 transition:	set fsm_busy
//			send request to memory for data	
// while in state 1:	get 2 bytes of data (4 cycles)
//			store those 2 bytes in the cache
//			transition when all data received
// 1 -> 0 transition:	write valid and tag bits
//			deassert stall signal


// stall if in the wait state
assign fsm_busy = (state == 1);

// write to cache while in wait state
assign write_data_array = (chunk_count[3] | chunk_count[2]) ? (state == 1) & memory_data_valid : 0;

// set Tag and Valid bits when all data is received
wire write_tag_array_in;
assign write_tag_array = (state == 1) & (next_state == 0);

// flop to delay the write_tag_array signal
//dff tag_delay_flop(.q(write_tag_array), .d(write_tag_array_in), .wen(1'b1), .clk(clk), .rst(~rst_n));
endmodule
