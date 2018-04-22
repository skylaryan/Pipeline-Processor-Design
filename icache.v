module icache()
input clk, rst_n;
input [15:0] address;
output fsm_memory;
output [15:0] instruction;

// block decoder
wire [6:0] block_address;
wire [127:0] BlockEnable;
assign block_address = address[8:1];
decoder_7_128 block_decoder(.block_address(block_address), .block(BlockEnable));

// Cache blocks and their data
DataArray cache_blocks(.clk(clk), .rst(~rst_n), input [15:0] DataIn(mem4c_in), .Write(write), input [127:0] BlockEnable, .WordEnable(offset), .DataOut(instruction));
// Cache blocks and their tag/valid bits
MetaDataArray cache_meta(.clk(clk), .rst(~rst_n), input [7:0] DataIn, input Write, input [127:0] BlockEnable, output [7:0] DataOut);

// 4-cycle memory
memory4c instruction_mem(data_out(mem4c_out), .data_in(), .addr(memory_address), enable(fsm_busy), .wr(0), .clk(clk), .rst(~rst_n), .data_valid(memory_data_valid));


// miss detection
assign valid = meta_out[7];
assign miss_detected = (~valid | address[15:9] == meta_out[6:0]);

// fsm for memory/cache control
// fsm inputs
wire miss_detected, memory_data_valid;
wire [15:0] memory_data, miss_address;
// fsm outputs
wire write_data_array, write_tag_array;
wire [15:0] memory_address;

cache_fill_fsm fsm(.clk(clk), .rst_n(rst_n), .miss_detected(miss_detected), .memory_data_valid(memory_data_valid), .memory_data(memory_data), .miss_address(miss_address), 
			.fsm_busy(fsm_memory), .write_data_array(write_data_array), .write_tag_array(write_tag_array), .memory_address(memory_address)); 


assign iinstruction = 

endmodule