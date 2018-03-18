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