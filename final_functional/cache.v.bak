module cache(clk, rst_n, address, mem_data, mem_enable, mem_wr, mem_data_valid, memory_address, instruction, filling_cache, miss_detected);
input clk, rst_n, mem_data_valid;
input [15:0] address, mem_data;
output [15:0] memory_address, instruction;
output mem_enable, filling_cache, miss_detected;
output mem_wr; // asserted for one clock cycle and passed to memory module

wire miss_detected;
wire [15:0] chunk_count, cache_data_address;
cache_fill_fsm fsm(.clk(clk), .rst_n(rst_n), .miss_address(address & 16'hFFF0), .memory_data_valid(mem_data_valid), .miss_detected(miss_detected), .write_tag_array(write_tag_array),
			.memory_address(memory_address), .data_address(cache_data_address), .write_data_array(write_data_array), .fsm_busy(filling_cache));

// take the address from the PC and decode it
wire [6:0] index_bits;
wire [127:0] BlockEnable;
assign index_bits = (filling_cache) ? memory_address[10:4] : address[10:4]; //melanie had cache_data_address instead of memory_address
decoder_7_128 block_decoder(.block_address(index_bits), .block(BlockEnable));

// take the address from the PC and choose which word is enabled
wire [2:0] offset_bits;
wire [7:0] WordEnable;
assign offset_bits = (filling_cache) ? cache_data_address[3:1] : address[3:1];
// Cache write: WriteEnable = 1, enable = 1   
// Cache read:	WriteEnable = 0, enable = 1
decoder_3_8 word_decoder(.index(offset_bits), .onehot_enable(WordEnable));

// cache blocks
wire [15:0] cached_instruction;
DataArray cache_blocks(.clk(clk), .rst(~rst_n), .DataIn(mem_data), .Write(write_data_array), .BlockEnable(BlockEnable), .WordEnable(WordEnable), .DataOut(cached_instruction));
assign instruction = (~write_data_array) ? cached_instruction : 16'h0000;

// cache meta
wire [7:0] meta_out, valid_tag;
assign valid_tag = {3'b100, address[15:11]}; // ? is there ever a time when the data in the cache is invalid?
MetaDataArray cache_meta(.clk(clk), .rst(~rst_n), .DataIn(valid_tag), .Write(write_tag_array), .BlockEnable(BlockEnable), .DataOut(meta_out));

// miss detected when the valid bit isn't set or tag bits don't match those for the decoded cache block and word
assign miss_detected = ~meta_out[7] | ~(address[15:11] == meta_out[4:0]);

assign mem_enable = 1'b1;
endmodule
