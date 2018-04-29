module icache(clk, rst_n, address, wait_for_memory, instruction, first_cycle, stall);

input clk, rst_n, first_cycle, stall;
input [15:0] address;
output wait_for_memory;
output [15:0] instruction;

// fsm inputs
wire miss_detected, memory_data_valid;
wire [15:0] mem4c_out;
// fsm outputs
wire write_data_array, write_tag_array;
wire [15:0] memory_address;
wire [2:0] current_word;
// fsm for memory/cache control
cache_fill_fsm fsm(.clk(clk), .rst_n(rst_n), .miss_detected(miss_detected), .memory_data_valid(memory_data_valid), .memory_data(mem4c_out), .miss_address(address), 
			.fsm_busy(wait_for_memory), .write_data_array(write_data_array), .write_tag_array(write_tag_array), .memory_address(memory_address), .chunk(current_word)); 


// block decoder
wire [6:0] block_index;
wire [127:0] BlockEnable;
assign block_index = address[10:4];

decoder_7_128 block_decoder(.block_address(block_index), .block(BlockEnable));

// Cache blocks and their data
wire [7:0] WordEnable;
wire test;
wire[2:0] updated_word;
adder_3b word_selector(.A(address[3:1]), .B(current_word), .sum(updated_word));
			
decoder_3_8 onehot_decoder (.index(updated_word), .onehot_enable(WordEnable));
//assign test = (memory_data_valid) ?  : 0;
//assign WordEnable = 8'b00000001;
DataArray cache_blocks(.clk(clk), .rst(~rst_n), .DataIn(mem4c_out), .Write(write_data_array), .BlockEnable(BlockEnable), .WordEnable(WordEnable), .DataOut(instruction));

// Cache blocks and their tag/valid bits
wire [7:0] meta_out, valid_tag;
assign valid_tag = {3'b100, memory_address[15:11]};
MetaDataArray cache_meta(.clk(clk), .rst(~rst_n), .DataIn(valid_tag), .Write(write_tag_array), .BlockEnable(BlockEnable), .DataOut(meta_out));

// 4-cycle memory
memory4c instruction_mem(.data_out(mem4c_out), .data_in(), .addr(memory_address), .enable(~stall), .wr(0), .clk(clk), .rst(~rst_n), .data_valid(memory_data_valid));


// miss detection
assign valid = meta_out[7];
assign miss_detected = first_cycle ? 1'b1 : (~valid | ~(address[15:9] == meta_out[6:0]));


//assign miss_detected = 1'b1;

endmodule
