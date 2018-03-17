module PADDSB_16b (S, A, B);

	input	[15:0] A, B;
	output	[15:0] S;

	SATADD_4b SA0 (
		.A(A[3:0]), .B(B[3:0]), .S(S[3:0])
	);
	SATADD_4b SA1 (
		.A(A[7:4]), .B(B[7:4]), .S(S[7:4])
	);
	SATADD_4b SA2 (
		.A(A[11:8]), .B(B[11:8]), .S(S[11:8])
	);
	SATADD_4b SA3 (
		.A(A[15:12]), .B(B[15:12]), .S(S[15:12])
	);

endmodule

module full_adder_1b (a, b, cin, cout, s);

	output s, cout;
	input a, b, cin;

	assign s = a ^ b ^ cin;
	assign cout = (a & b) | ((a ^ b) & cin);

endmodule

module SATADD_4b (S, A, B);

	input [3:0] A, B; 	// Input values
	output [3:0] S; 	// sum output

	wire [3:0] c;
	wire both_neg, both_pos;
	wire [3:0] FA_out;

	full_adder_1b FA0 (
		.a		(A[0]),
		.b		(B[0]),
		.cin	(1'b0),
		.cout	(c[0]),
		.s		(FA_out[0])
	);
	full_adder_1b FA1 (
		.a		(A[1]),
		.b		(B[1]),
		.cin	(c[0]),
		.cout	(c[1]),
		.s		(FA_out[1])
	);
	full_adder_1b FA2 (
		.a		(A[2]),
		.b		(B[2]),
		.cin	(c[1]),
		.cout	(c[2]),
		.s		(FA_out[2])
	);
	full_adder_1b FA3 (
		.a		(A[3]),
		.b		(B[3]),
		.cin	(c[2]),
		.cout	(c[3]),
		.s		(FA_out[3])
	);

	assign both_neg = A[3] & B[3];
	assign both_pos = ~(A[3] | B[3]);
	assign sat_neg = both_neg & (~FA_out[3]);
	assign sat_pos = both_pos & FA_out[3];

	assign S[3:0] = sat_neg? 4'b1000 : pos_neg? 4'b0111 : FA_out[3:0];

endmodule