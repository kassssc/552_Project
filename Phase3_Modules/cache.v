module CACHE (
	input clk,
	input rst,

	// PIPELINE Interface
	input pipe_MemRead, // does the pipeline want to read something from mem?
	input [15:0] pipe_read_addr, // PC for I-cache, mem_read_addr for D-cache
	input pipe_MemWrite, // does the pipeline want to write to mem? always 0 for I-cache
	input [15:0] pipe_mem_write_addr, // mem addr the pipeline wants to write to
	input [15:0] pipe_mem_write_data, // data the pipeline wants to write to mem

	// Cache gets data from memory (when it wants to)
	input MemDataValid,	// is data from memory valid?
	input [15:0] mem_read_data, // data read from memory

	// Cache controls Memory module (when it wants to)
	output cache_MemRead, // does cache want any data from mem?
	output cache_MemWrite, // Does the cache want to write to mem?
	output [15:0] cache_mem_read_addr, // addr cache wants to read from mem when transferring data

	output [15:0] cache_data_out, // data read from the cache
	output stall // Stall pipeline while cache is busy transferring data from mem
);

wire WriteTagArray, WriteDataArray, CacheMiss, CacheHit, CacheBusy;
wire[15:0] addr;

wire[7:0] meta_data_in, meta_data_out;
wire[15:0] cache_data_in;

wire[4:0] tag;
wire[6:0] set_index;
wire[3:0] block_offset;

wire[127:0] block_select_one_hot;	// one-hot selects the set index in cache
wire[7:0] word_select_one_hot;		// one-hot selects word in a cache block
wire[15:0] data_block_select_one_hot;

assign addr[15:0] = (pipe_MemWrite)? pipe_mem_write_addr[15:0] : pipe_read_addr[15:0];

assign tag = addr[15:11];
assign set_index = addr[10:4];
assign block_offset = addr[3:0];

assign CacheHit = meta_data_out[5] & (meta_data_out[4:0] == tag[4:0]);
assign CacheMiss = ~CacheHit & (pipe_MemRead | pipe_MemWrite);

assign mem_write_addr = pipe_mem_write_addr;
assign mem_write_data = pipe_mem_write_data;

DECODER_3_8 block_offset_decoder (
	.id_in(block_offset[3:1]),
	.one_hot_out(word_select_one_hot[7:0])
);
DECODER_7_128 set_index_decoder (
	.id_in(set_index[6:0]),
	.one_hot_out(block_select_one_hot[127:0])
);

cache_fill_FSM cache_ctrl (
	.clk(clk),
	.rst(rst),
	.miss_detected(CacheMiss),
	.memory_data_valid(MemDataValid),
	.miss_address(addr[15:0]),
	.memory_data(mem_read_data[15:0]),

	.fsm_busy(CacheBusy),
	.write_data_array(WriteDataArray),
	.write_tag_array(WriteTagArray),
	.memory_address(cache_mem_read_addr[15:0])
);

assign meta_data_in[7:0] = {3'b1, tag[4:0]};

MetaDataArray meta (
	.clk(clk),
	.rst(rst),
	.DataIn(meta_data_in[7:0]),
	.Write(WriteTagArray),
	.BlockEnable(block_select_one_hot[15:0]),
	.DataOut(meta_data_out[7:0])
);

assign data_block_select_one_hot = CacheHit? block_select_one_hot[15:0] : 16'h0000;
assign CacheWrite = WriteDataArray | pipe_MemWrite;
assign cache_data_in = MemDataValid? mem_read_data[15:0] : pipe_mem_write_data;

DataArray data (
	.clk(clk),
	.rst(rst),
	.DataIn(cache_data_in[15:0]),
	.Write(CacheWrite),
	.BlockEnable(data_block_select_one_hot[15:0]),
	.WordEnable(word_select_one_hot[7:0]),
	.DataOut(cache_data_out[15:0])
);

assign cache_MemWrite = CacheWrite;	// Write to mem also when writing to cache
assign stall = CacheBusy; // Stall if transferring data from memory

endmodule