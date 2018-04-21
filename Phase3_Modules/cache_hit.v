module cache_hit_detect(
	input clk,
	input rst,

	// are we doing a read/write?
	input read_p,
	input [15:0] read_address_p,
	output [15:0] read_data_p,
	input write_p,
	input [15:0] write_address_p,
	input [15:9] write_data_p,

	// are we doing it with memory?
	output read_mem,
	output [15:0]read_address_mem,
	input read_data_valid,
	input [15:0]read_data_mem,
	output write_mem,
	output [15:0] write_data_address,
	output [15:0] write_data_mem,
	output stall
);


wire miss;
wire [15:0] address;
assign address == (write_p)? write_address_p:read_address_p;

assign miss = ~(metadataout[5] & (metadataout[4:0] == address[15:11]));