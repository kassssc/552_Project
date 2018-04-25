module cache_fill_FSM (
	input clk,
	input rst,
	input miss_detected, // active high when tag match logic detects a miss
	input memory_data_valid, // active high indicates valid data returning on memory bus
	input[15:0] miss_address, // address that missed the cache
	input[15:0] memory_data, // data returned by memory (after  delay)
	output fsm_busy, // asserted while FSM is busy handling the miss (can be used as pipeline stall signal)
	output[3:0] fsm_offset,
	output write_data_array, // write enable to cache data array to signal when filling with memory_data
	output write_tag_array, // write enable to cache tag array to write tag and valid bit once all words are filled in to data array
	output[15:0] memory_address // address to read from memory
);

wire fsm_busy_new, fsm_busy_curr, finish_data_transfer;
wire [3:0] block_offset_new, block_offset_curr;
wire [15:0] base_address, block_offset_16b;

assign fsm_busy_new = fsm_busy_curr? (~finish_data_transfer) : miss_detected;
assign block_offset_16b = {{13{1'b0}}, block_offset_curr[2:0]};
assign fsm_offset = block_offset_curr[3:0];

dff state_fsm_busy (
	.d(fsm_busy_new),
	.q(fsm_busy_curr),
	.wen(1'b1),
	.clk(clk),
	.rst(rst)
);

reg_4b block_offset_counter (
	.reg_new(block_offset_new[3:0]),
	.reg_current(block_offset_curr[3:0]),
	.wen(fsm_busy_curr & memory_data_valid),
	.clk(clk),
	.rst(rst | finish_data_transfer)
);

reg_16b mem_addr (
	.reg_new(miss_address[15:0]),
	.reg_current(base_address[15:0]),
	.wen(~fsm_busy_curr & miss_detected),
	.clk(clk),
	.rst(rst | finish_data_transfer)
);

full_adder_4b block_offset_adder (
	.A(block_offset_curr[3:0]),	.B(4'b0010), .cin(1'b0),
	.S(block_offset_new[3:0]),	.cout(finish_data_transfer)
);

CLA_16b addsub_16b (
	.A(base_address[15:0]),		.B(block_offset_16b[15:0]),		.sub(1'b0),
	.S(memory_address[15:0]),	.ovfl(), .neg()
);

assign fsm_busy = fsm_busy_curr;
assign write_data_array = fsm_busy_curr;
assign write_tag_array = fsm_busy_curr & finish_data_transfer;

endmodule