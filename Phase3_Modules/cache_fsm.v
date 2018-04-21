module cache_fill_FSM (
	input clk,
	input rst_n,
	input miss_detected, // active high when tag match logic detects a miss
	input memory_data_valid, // active high indicates valid data returning on memory bus
	input[15:0] miss_address, // address that missed the cache
	input[15:0] memory_data, // data returned by memory (after  delay)
	output fsm_busy, // asserted while FSM is busy handling the miss (can be used as pipeline stall signal)
	output write_data_array, // write enable to cache data array to signal when filling with memory_data
	output write_tag_array, // write enable to cache tag array to write tag and valid bit once all words are filled in to data array
	output[15:0] memory_address // address to read from memory
);

wire fsm_busy_new, fsm_busy_curr, finish_data_transfer;
wire [2:0] block_offset_new, block_offset_curr;
wire [15:0] base_address, block_offset_16b;

assign fsm_busy_new = fsm_busy_curr? (~finish_data_transfer) : miss_detected;
assign block_offset_16b = {{13{1'b0}}, block_offset_curr[2:0]};

dff state_fsm_busy (
	.d(fsm_busy_new),
	.q(fsm_busy_curr),
	.wen(1'b1),
	.clk(clk),
	.rst(~rst_n)
);

reg_3b block_offset_counter (
	.reg_new(block_offset_new[2:0]),
	.reg_current(block_offset_curr[2:0]),
	.wen(fsm_busy_curr & memory_data_valid),
	.clk(clk),
	.rst(~rst_n | finish_data_transfer)
);

reg_16b mem_addr (
	.reg_new(miss_address[15:0]),
	.reg_current(base_address[15:0]),
	.wen(~fsm_busy_curr & miss_detected),
	.clk(clk),
	.rst(~rst_n | finish_data_transfer)
);

adder_3b block_offset_adder (
	.A(block_offset_curr[2:0]),	.B(3'b001),
	.S(block_offset_new[2:0]),	.Ovfl(finish_data_transfer)
);

CLA_16b addsub_16b (
	.A(base_address[15:0]),		.B(block_offset_16b[15:0]),		.sub(1'b0),
	.S(memory_address[15:0]),	.ovfl(), .neg()
);

assign fsm_busy = fsm_busy_curr;
assign write_data_array = fsm_busy_curr;
assign write_tag_array = fsm_busy_curr & finish_data_transfer;

endmodule

module dff (q, d, wen, clk, rst);

	output	q;		// DFF output
	input	d;		// DFF input
	input	wen;	// Write Enable
	input	clk;	// Clock
	input	rst;	// Reset (used synchronously)

	reg	state;

	assign q = state;

	always @(posedge clk) begin
	  state = rst ? 0 : (wen ? d : state);
	end

endmodule

module reg_3b(
	input [2:0]reg_new,
	input wen,
	input clk,
	input rst,
	output [2:0]reg_current
);

dff b0(
	.d(reg_new[0]), .q(reg_current[0]), .wen(wen), .clk(clk), .rst(rst)
);
dff b1(
	.d(reg_new[1]), .q(reg_current[1]), .wen(wen), .clk(clk), .rst(rst)
);
dff b2(
	.d(reg_new[2]), .q(reg_current[2]), .wen(wen), .clk(clk), .rst(rst)
);

endmodule

module reg_16b(
	input [15:0]reg_new,
	input wen,
	input clk,
	input rst,
	output [15:0]reg_current
);

dff b0(
	.d(reg_new[0]), .q(reg_current[0]), .wen(wen), .clk(clk), .rst(rst)
);
dff b1(
	.d(reg_new[1]), .q(reg_current[1]), .wen(wen), .clk(clk), .rst(rst)
);
dff b2(
	.d(reg_new[2]), .q(reg_current[2]), .wen(wen), .clk(clk), .rst(rst)
);
dff b3(
	.d(reg_new[3]), .q(reg_current[3]), .wen(wen), .clk(clk), .rst(rst)
);
dff b4(
	.d(reg_new[4]), .q(reg_current[4]), .wen(wen), .clk(clk), .rst(rst)
);
dff b5(
	.d(reg_new[5]), .q(reg_current[5]), .wen(wen), .clk(clk), .rst(rst)
);
dff b6(
	.d(reg_new[6]), .q(reg_current[6]), .wen(wen), .clk(clk), .rst(rst)
);
dff b7(
	.d(reg_new[7]), .q(reg_current[7]), .wen(wen), .clk(clk), .rst(rst)
);
dff b8(
	.d(reg_new[8]), .q(reg_current[8]), .wen(wen), .clk(clk), .rst(rst)
);
dff b9(
	.d(reg_new[9]), .q(reg_current[9]), .wen(wen), .clk(clk), .rst(rst)
);
dff b10(
	.d(reg_new[10]), .q(reg_current[10]), .wen(wen), .clk(clk), .rst(rst)
);
dff b11(
	.d(reg_new[11]), .q(reg_current[11]), .wen(wen), .clk(clk), .rst(rst)
);
dff b12(
	.d(reg_new[12]), .q(reg_current[12]), .wen(wen), .clk(clk), .rst(rst)
);
dff b13(
	.d(reg_new[13]), .q(reg_current[13]), .wen(wen), .clk(clk), .rst(rst)
);
dff b14(
	.d(reg_new[14]), .q(reg_current[14]), .wen(wen), .clk(clk), .rst(rst)
);
dff b15(
	.d(reg_new[15]), .q(reg_current[15]), .wen(wen), .clk(clk), .rst(rst)
);

endmodule

module CLA_1b (a, b, c_in, g_out, p_out, s);

	input	a, b, c_in;
	output	g_out, p_out, s;

	assign s = a ^ b ^ c_in;
	assign p_out = a ^ b;
	assign g_out = a & b;

endmodule

module CLA_4b (a, b, c_in, pg_out, gg_out, s);

	input	[3:0] a, b;
	input	c_in;
	output	[3:0] s;
	output	pg_out, gg_out;

	wire	[3:0] c, g, p;

	assign c[0] = c_in;
	assign c[1] = g[0] | (p[0] & c[0]);
	assign c[2] = g[1] | (g[0] & p[1]) | (p[1] & p[0] & c[0]);
	assign c[3] = g[2] | (g[1] & p[2]) | (g[0] & p[2] & p[1]) | (p[2] & p[1] & p[0] & c[0]);

	assign pg_out = p[3] & p[2] & p[1] & p[0];
	assign gg_out = g[3] | (g[2] & p[3]) | (g[1] & p[3] & p[2]) | (g[0] & p[3] & p[2] & p[1]);

	CLA_1b cla0 (
		.a(a[0]), .b(b[0]), .c_in(c[0]), .g_out(g[0]), .p_out(p[0]), .s(s[0])
	);
	CLA_1b cla1 (
		.a(a[1]), .b(b[1]), .c_in(c[1]), .g_out(g[1]), .p_out(p[1]), .s(s[1])
	);
	CLA_1b cla2 (
		.a(a[2]), .b(b[2]), .c_in(c[2]), .g_out(g[2]), .p_out(p[2]), .s(s[2])
	);
	CLA_1b cla3 (
		.a(a[3]), .b(b[3]), .c_in(c[3]), .g_out(g[3]), .p_out(p[3]), .s(s[3])
	);

endmodule

module CLA_16b (A, B, sub, S, ovfl, neg);

	input [15:0] A, B;
	input sub;
	output [15:0] S;
	output ovfl, neg;

	wire [15:0] B_in, addsub_out;
	wire [3:0] c, g, p;
	wire G, P, both_neg, both_pos, sat_neg, sat_pos;

	assign B_in[15:0] = sub? ~B[15:0] : B[15:0];

	assign c[0] = sub;
	assign c[1] = g[0] | (p[0] & c[0]);
	assign c[2] = g[1] | (g[0] & p[1]) | (p[1] & p[0] & c[0]);
	assign c[3] = g[2] | (g[1] & p[2]) | (g[0] & p[2] & p[1]) | (p[2] & p[1] & p[0] & c[0]);

	assign P = p[3] & p[2] & p[1] & p[0];
	assign G = g[3] | (g[2] & p[3]) | (g[1] & p[3] & p[2]) | (g[0] & p[3] & p[2] & p[1]);

	CLA_4b cla_0_3 (
		.a(A[3:0]), .b(B_in[3:0]), .c_in(c[0]), .gg_out(g[0]), .pg_out(p[0]), .s(addsub_out[3:0])
	);
	CLA_4b cla_4_7 (
		.a(A[7:4]), .b(B_in[7:4]), .c_in(c[1]), .gg_out(g[1]), .pg_out(p[1]), .s(addsub_out[7:4])
	);
	CLA_4b cla_8_11 (
		.a(A[11:8]), .b(B_in[11:8]), .c_in(c[2]), .gg_out(g[2]), .pg_out(p[2]), .s(addsub_out[11:8])
	);
	CLA_4b cla_12_15 (
		.a(A[15:12]), .b(B_in[15:12]), .c_in(c[3]), .gg_out(g[3]), .pg_out(p[3]), .s(addsub_out[15:12])
	);

	assign both_neg = A[15] & B_in[15];
	assign both_pos = ~A[15] & ~B_in[15];
	assign sat_neg = both_neg & (~addsub_out[15]);
	assign sat_pos = both_pos & addsub_out[15];

	assign S[15:0] = sat_neg? 16'h8000 : (sat_pos? 16'h7FFF : addsub_out[15:0]);

	assign ovfl = sat_neg | sat_pos;
	assign neg = S[15];

endmodule

module full_adder_1b (a, b, cin, cout, s);

	output s, cout;
	input a, b, cin;

	assign s = a ^ b ^ cin;
	assign cout = (a & b) | ((a ^ b) & cin);

endmodule

module adder_3b (S, Ovfl, A, B);

	input [2:0] A, B; 	// Input values
	output [2:0] S; 	// sum output
	output Ovfl; 		// To indicate overflow

	wire cout0, cout1;

	full_adder_1b FA0 (
		.a(A[0]), .b(B[0]), .cin(1'b0), .cout(cout0), .s(S[0])
	);
	full_adder_1b FA1 (
		.a(A[1]), .b(B[1]), .cin(cout0), .cout(cout1), .s(S[1])
	);
	full_adder_1b FA2 (
		.a(A[2]), .b(B[2]), .cin(cout1), .cout(Ovfl), .s(S[2])
	);

endmodule