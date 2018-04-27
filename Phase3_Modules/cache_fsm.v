module cache_fill_FSM (
	input clk,
	input rst,
	input miss_detected, // active high when tag match logic detects a miss
	input memory_data_valid, // active high indicates valid data returning on memory bus
	input[15:0] miss_address, // address that missed the cache

	output fsm_busy, // asserted while FSM is busy handling the miss (can be used as pipeline stall signal)
	output[3:0] fsm_offset, // offset added to the address when transferring blocks
	output write_data_array, // write enable to cache data array to signal when filling with memory_data
	output write_tag_array, // write enable to cache tag array to write tag and valid bit once all words are filled in to data array
	output[15:0] memory_address, // address to read from memory
	output mem_read,
	output finished
);

wire fsm_busy_new, fsm_busy_curr, finish_data_transfer;
wire [3:0] block_offset_new, block_offset_curr;
wire [15:0] base_address, block_offset_16b;

wire [3:0] mem_latency_wait_counter_new, mem_latency_wait_counter_curr;
wire finish_mem_latency_wait;

// Is it currently busy? if yes and not finished waitinf for mem latency, it stays busy, otherwise busy if cache miss
assign fsm_busy_new = fsm_busy_curr? (~finish_mem_latency_wait) : miss_detected;

// sign extend block offset to 16b
assign block_offset_16b = {{12{1'b0}}, block_offset_curr[3:0]};

// current block offset
assign fsm_offset = block_offset_curr[3:0];

assign finished = finish_data_transfer;


// Store the current state of the cache "is it busy transferring data from mem?"
dff state_fsm_busy (
	.d(fsm_busy_new),
	.q(fsm_busy_curr),
	.wen(1'b1),
	.clk(clk),
	.rst(rst)
);

// Stores the base address of the block, the offset adds to this address
reg_16b mem_addr (
	.reg_new(miss_address[15:0]),
	.reg_current(base_address[15:0]),
	.wen(~fsm_busy_curr & miss_detected),
	.clk(clk),
	.rst(rst | finish_data_transfer)
);

// Persistent storage of the current offset being added to the base addr when transferring data
reg_4b block_offset_counter (
	.reg_new(block_offset_new[3:0]),
	.reg_current(block_offset_curr[3:0]),
	.wen(fsm_busy_curr & memory_data_valid & ~finish_data_transfer),
	.clk(clk),
	.rst(rst | finish_mem_latency_wait)// reset when data transfer done
);

// Adds 2 to the block offset every cycle, reset to 0 when data transfer done
full_adder_4b block_offset_adder (
	.A(block_offset_curr[3:0]),	.B(4'b0010), .cin(1'b0),
	.S(block_offset_new[3:0]),	.cout(finish_data_transfer)
);

// Persistent storage of the current offset being added to the base addr when transferring data
reg_4b mem_latency_wait (
	.reg_new(mem_latency_wait_counter_new[3:0]),
	.reg_current(mem_latency_wait_counter_curr[3:0]),
	.wen(~finish_mem_latency_wait & fsm_busy_curr & memory_data_valid),
	.clk(clk),
	.rst(rst | finish_mem_latency_wait)// reset when data transfer done
);

// Adds 2 to the block offset every cycle, reset to 0 when data transfer done
full_adder_2b mem_latency_wait_adder (
	.A(mem_latency_wait_counter_curr[1:0]),	.B(2'b01), .cin(1'b0),
	.S(mem_latency_wait_counter_new[1:0]),	.cout(finish_mem_latency_wait)
);

// adds the offset to the base block addr
CLA_16b addsub_16b (
	.A(base_address[15:0]),		.B(block_offset_16b[15:0]),		.sub(1'b0),
	.S(memory_address[15:0]),	.ovfl(), .neg()
);

assign fsm_busy = fsm_busy_curr;
assign write_data_array = fsm_busy_curr;
assign write_tag_array = fsm_busy_curr & finish_data_transfer;
assign mem_read = ~finish_data_transfer;

endmodule