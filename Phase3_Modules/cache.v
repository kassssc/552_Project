module CACHE (
	input clk,
	input rst,

	// PIPELINE Interface
	input pipe_MemRead, // does the pipeline want to read something from mem?
	input [15:0] pipe_read_addr, // PC for I-cache, mem_read_addr for D-cache
	input pipe_MemWrite, // always 0 for I-cache
	input [15:0] pipe_mem_write_addr, // mem addr the pipeline wants to write to
	input [15:0] pipe_mem_write_data, // data the pipeline wants to write to mem

	output [15:0] cache_data_out, // data read from the cache

	// MEMORY MODULE INTERFACE
	// Interfaces with memory
	// These come from pipeline registers MEM stage
	input MemDataValid,	// is data from memory valid?
	input [15:0] mem_read_data, // data read from memory

	output MemRead, // does cache want any data from mem?
	output [15:0] mem_read_addr, // addr cache wants to read from mem when transferring data
	output MemWrite, // Does the cache want to write to mem?
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
	.memory_address(mem_read_addr[15:0])
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

assign MemWrite = CacheWrite;	// Write to mem also when writing to cache
assign stall = CacheBusy; // Stall if transferring data from memory

endmodule


module DECODER_3_8(
	input[2:0] id_in,
	output[8:0] one_hot_out
);

	reg [8:0]one_hot_reg;
	assign one_hot_out = one_hot_reg;

	always@(*) begin
		case (id_in)
			3'b000: one_hot_reg = 8'h01;
			3'b001: one_hot_reg = 8'h02;
			3'b010: one_hot_reg = 8'h04;
			3'b011: one_hot_reg = 8'h08;
			3'b100: one_hot_reg = 8'h10;
			3'b101: one_hot_reg = 8'h20;
			3'b110: one_hot_reg = 8'h40;
			3'b111: one_hot_reg = 8'h80;
			default : one_hot_reg = 8'h00;
		endcase
	end
endmodule

module DECODER_7_128(
	input[6:0] id_in,
	output[127:0] one_hot_out
);

	reg [127:0]one_hot_reg;
	assign one_hot_out = one_hot_reg;

	always@(*) begin
		case (id_in)
			7'h 0: one_hot_reg = 128'h                               1;
			7'h 1: one_hot_reg = 128'h                               2;
			7'h 2: one_hot_reg = 128'h                               4;
			7'h 3: one_hot_reg = 128'h                               8;
			7'h 4: one_hot_reg = 128'h                              10;
			7'h 5: one_hot_reg = 128'h                              20;
			7'h 6: one_hot_reg = 128'h                              40;
			7'h 7: one_hot_reg = 128'h                              80;
			7'h 8: one_hot_reg = 128'h                             100;
			7'h 9: one_hot_reg = 128'h                             200;
			7'h a: one_hot_reg = 128'h                             400;
			7'h b: one_hot_reg = 128'h                             800;
			7'h c: one_hot_reg = 128'h                            1000;
			7'h d: one_hot_reg = 128'h                            2000;
			7'h e: one_hot_reg = 128'h                            4000;
			7'h f: one_hot_reg = 128'h                            8000;
			7'h10: one_hot_reg = 128'h                           10000;
			7'h11: one_hot_reg = 128'h                           20000;
			7'h12: one_hot_reg = 128'h                           40000;
			7'h13: one_hot_reg = 128'h                           80000;
			7'h14: one_hot_reg = 128'h                          100000;
			7'h15: one_hot_reg = 128'h                          200000;
			7'h16: one_hot_reg = 128'h                          400000;
			7'h17: one_hot_reg = 128'h                          800000;
			7'h18: one_hot_reg = 128'h                         1000000;
			7'h19: one_hot_reg = 128'h                         2000000;
			7'h1a: one_hot_reg = 128'h                         4000000;
			7'h1b: one_hot_reg = 128'h                         8000000;
			7'h1c: one_hot_reg = 128'h                        10000000;
			7'h1d: one_hot_reg = 128'h                        20000000;
			7'h1e: one_hot_reg = 128'h                        40000000;
			7'h1f: one_hot_reg = 128'h                        80000000;
			7'h20: one_hot_reg = 128'h                       100000000;
			7'h21: one_hot_reg = 128'h                       200000000;
			7'h22: one_hot_reg = 128'h                       400000000;
			7'h23: one_hot_reg = 128'h                       800000000;
			7'h24: one_hot_reg = 128'h                      1000000000;
			7'h25: one_hot_reg = 128'h                      2000000000;
			7'h26: one_hot_reg = 128'h                      4000000000;
			7'h27: one_hot_reg = 128'h                      8000000000;
			7'h28: one_hot_reg = 128'h                     10000000000;
			7'h29: one_hot_reg = 128'h                     20000000000;
			7'h2a: one_hot_reg = 128'h                     40000000000;
			7'h2b: one_hot_reg = 128'h                     80000000000;
			7'h2c: one_hot_reg = 128'h                    100000000000;
			7'h2d: one_hot_reg = 128'h                    200000000000;
			7'h2e: one_hot_reg = 128'h                    400000000000;
			7'h2f: one_hot_reg = 128'h                    800000000000;
			7'h30: one_hot_reg = 128'h                   1000000000000;
			7'h31: one_hot_reg = 128'h                   2000000000000;
			7'h32: one_hot_reg = 128'h                   4000000000000;
			7'h33: one_hot_reg = 128'h                   8000000000000;
			7'h34: one_hot_reg = 128'h                  10000000000000;
			7'h35: one_hot_reg = 128'h                  20000000000000;
			7'h36: one_hot_reg = 128'h                  40000000000000;
			7'h37: one_hot_reg = 128'h                  80000000000000;
			7'h38: one_hot_reg = 128'h                 100000000000000;
			7'h39: one_hot_reg = 128'h                 200000000000000;
			7'h3a: one_hot_reg = 128'h                 400000000000000;
			7'h3b: one_hot_reg = 128'h                 800000000000000;
			7'h3c: one_hot_reg = 128'h                1000000000000000;
			7'h3d: one_hot_reg = 128'h                2000000000000000;
			7'h3e: one_hot_reg = 128'h                4000000000000000;
			7'h3f: one_hot_reg = 128'h                8000000000000000;
			7'h40: one_hot_reg = 128'h               10000000000000000;
			7'h41: one_hot_reg = 128'h               20000000000000000;
			7'h42: one_hot_reg = 128'h               40000000000000000;
			7'h43: one_hot_reg = 128'h               80000000000000000;
			7'h44: one_hot_reg = 128'h              100000000000000000;
			7'h45: one_hot_reg = 128'h              200000000000000000;
			7'h46: one_hot_reg = 128'h              400000000000000000;
			7'h47: one_hot_reg = 128'h              800000000000000000;
			7'h48: one_hot_reg = 128'h             1000000000000000000;
			7'h49: one_hot_reg = 128'h             2000000000000000000;
			7'h4a: one_hot_reg = 128'h             4000000000000000000;
			7'h4b: one_hot_reg = 128'h             8000000000000000000;
			7'h4c: one_hot_reg = 128'h            10000000000000000000;
			7'h4d: one_hot_reg = 128'h            20000000000000000000;
			7'h4e: one_hot_reg = 128'h            40000000000000000000;
			7'h4f: one_hot_reg = 128'h            80000000000000000000;
			7'h50: one_hot_reg = 128'h           100000000000000000000;
			7'h51: one_hot_reg = 128'h           200000000000000000000;
			7'h52: one_hot_reg = 128'h           400000000000000000000;
			7'h53: one_hot_reg = 128'h           800000000000000000000;
			7'h54: one_hot_reg = 128'h          1000000000000000000000;
			7'h55: one_hot_reg = 128'h          2000000000000000000000;
			7'h56: one_hot_reg = 128'h          4000000000000000000000;
			7'h57: one_hot_reg = 128'h          8000000000000000000000;
			7'h58: one_hot_reg = 128'h         10000000000000000000000;
			7'h59: one_hot_reg = 128'h         20000000000000000000000;
			7'h5a: one_hot_reg = 128'h         40000000000000000000000;
			7'h5b: one_hot_reg = 128'h         80000000000000000000000;
			7'h5c: one_hot_reg = 128'h        100000000000000000000000;
			7'h5d: one_hot_reg = 128'h        200000000000000000000000;
			7'h5e: one_hot_reg = 128'h        400000000000000000000000;
			7'h5f: one_hot_reg = 128'h        800000000000000000000000;
			7'h60: one_hot_reg = 128'h       1000000000000000000000000;
			7'h61: one_hot_reg = 128'h       2000000000000000000000000;
			7'h62: one_hot_reg = 128'h       4000000000000000000000000;
			7'h63: one_hot_reg = 128'h       8000000000000000000000000;
			7'h64: one_hot_reg = 128'h      10000000000000000000000000;
			7'h65: one_hot_reg = 128'h      20000000000000000000000000;
			7'h66: one_hot_reg = 128'h      40000000000000000000000000;
			7'h67: one_hot_reg = 128'h      80000000000000000000000000;
			7'h68: one_hot_reg = 128'h     100000000000000000000000000;
			7'h69: one_hot_reg = 128'h     200000000000000000000000000;
			7'h6a: one_hot_reg = 128'h     400000000000000000000000000;
			7'h6b: one_hot_reg = 128'h     800000000000000000000000000;
			7'h6c: one_hot_reg = 128'h    1000000000000000000000000000;
			7'h6d: one_hot_reg = 128'h    2000000000000000000000000000;
			7'h6e: one_hot_reg = 128'h    4000000000000000000000000000;
			7'h6f: one_hot_reg = 128'h    8000000000000000000000000000;
			7'h70: one_hot_reg = 128'h   10000000000000000000000000000;
			7'h71: one_hot_reg = 128'h   20000000000000000000000000000;
			7'h72: one_hot_reg = 128'h   40000000000000000000000000000;
			7'h73: one_hot_reg = 128'h   80000000000000000000000000000;
			7'h74: one_hot_reg = 128'h  100000000000000000000000000000;
			7'h75: one_hot_reg = 128'h  200000000000000000000000000000;
			7'h76: one_hot_reg = 128'h  400000000000000000000000000000;
			7'h77: one_hot_reg = 128'h  800000000000000000000000000000;
			7'h78: one_hot_reg = 128'h 1000000000000000000000000000000;
			7'h79: one_hot_reg = 128'h 2000000000000000000000000000000;
			7'h7a: one_hot_reg = 128'h 4000000000000000000000000000000;
			7'h7b: one_hot_reg = 128'h 8000000000000000000000000000000;
			7'h7c: one_hot_reg = 128'h10000000000000000000000000000000;
			7'h7d: one_hot_reg = 128'h20000000000000000000000000000000;
			7'h7e: one_hot_reg = 128'h40000000000000000000000000000000;
			7'h7f: one_hot_reg = 128'h80000000000000000000000000000000;
			default : one_hot_reg = 128'h0;
		endcase
	end
endmodule