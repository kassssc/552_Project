module PC_control(C, I, F, PC_in, PC_out);

	input	[2:0]	C;	// Condition Encoding
	input	[2:0]	F;	// [ N V Z ]
	input	[8:0]	I;
	input	[15:0]	PC_in;
	output	[15:0]	PC_out;

	wire neg_flag, ovfl_flag, zero_flag, branch;
	wire NEQ, EQ, GT, LT, GEQ, LEQ, OVFL, UNCOND;
	wire [15:0] target, shifted_I, PC_plus_2;
	wire dummy1, dummy2;	 // Dummy for unused adder overflow flags

	assign neg_flag = F[2];
	assign ovfl_flag = F[1];
	assign zero_flag = F[0];

	assign NEQ    = ~C[2] & ~C[1] & ~C[0];
	assign EQ     = ~C[2] & ~C[1] &  C[0];
	assign GT     = ~C[2] &  C[1] & ~C[0];
	assign LT     = ~C[2] &  C[1] &  C[0];
	assign GEQ    =  C[2] & ~C[1] & ~C[0];
	assign LEQ    =  C[2] & ~C[1] &  C[0];
	assign OVFL   =  C[2] &  C[1] & ~C[0];
	assign UNCOND =  C[2] &  C[1] &  C[0];

	assign branch = ( (NEQ & ~zero_flag) |
					  (EQ & zero_flag) |
					  (GT & ~zero_flag & ~neg_flag) |
					  (LT & neg_flag) |
					  (GEQ & (zero_flag | (~zero_flag & ~neg_flag))) |
					  (LEQ & (zero_flag | neg_flag)) |
					  (OVFL & ovfl_flag) |
					  UNCOND
					);

	assign shifted_I[15:0] = {16{I[8:0] << 1}};

	// PC + 2
	add_16bit PC_adder (
		.Sum(PC_plus_2),	.Ovfl(dummy1),	.A(PC_in),		.B(16'h0002)
	);

	// Target = PC + 2 + (I << 1)
	add_16bit Target_adder (
		.Sum(target),		.Ovfl(dummy2),	.A(PC_plus_2),	.B(shifted_I)
	);

	assign PC_out = branch? target : PC_plus_2;

endmodule

module full_adder_1bit (a, b, cin, cout, s);

	output s, cout;
	input a, b, cin;

	assign s = a ^ b ^ cin;
	assign cout = (a & b) | ((a ^ b) & cin);

endmodule

module add_16bit (Sum, Ovfl, A, B);

	input [15:0] A, B; 	// Input values
	output [15:0] Sum; 	// sum output
	output Ovfl; 		// To indicate overflow

	wire cout0, cout1, cout2, cout3, cout4, cout5, cout6, cout7;
	wire cout8, cout9, cout10, cout11, cout12, cout13, cout14;

	full_adder_1bit FA0 (
		.a (A[0]),	.b (B[0]),	.cin (1'b0),	.cout (cout0),	.s (Sum[0])
	);
	full_adder_1bit FA1 (
		.a (A[1]),	.b(B[1]),	.cin (cout0),	.cout (cout1),	.s (Sum[1])
	);
	full_adder_1bit FA2 (
		.a (A[2]),	.b (B[2]),	.cin (cout1),	.cout (cout2),	.s (Sum[2])
	);
	full_adder_1bit FA3 (
		.a (A[3]),	.b (B[3]),	.cin (cout2),	.cout (cout3),	.s (Sum[3])
	);
	full_adder_1bit FA4 (
		.a (A[4]),	.b(B[4]),	.cin (cout3),	.cout (cout4),	.s (Sum[4])
	);
	full_adder_1bit FA5 (
		.a (A[5]),	.b (B[5]),	.cin (cout4),	.cout (cout5),	.s (Sum[5])
	);
	full_adder_1bit FA6 (
		.a (A[6]),	.b (B[6]),	.cin (cout5),	.cout (cout6),	.s (Sum[6])
	);
	full_adder_1bit FA7 (
		.a (A[7]),	.b(B[7]),	.cin (cout6),	.cout (cout7),	.s (Sum[7])
	);
	full_adder_1bit FA8 (
		.a (A[8]),	.b (B[8]),	.cin (cout7),	.cout (cout8),	.s (Sum[8])
	);
	full_adder_1bit FA9 (
		.a (A[9]),	.b (B[9]),	.cin (cout8),	.cout (cout9),	.s (Sum[9])
	);
	full_adder_1bit FA10 (
		.a (A[10]),	.b(B[10]),	.cin (cout9),	.cout (cout10),	.s (Sum[10])
	);
	full_adder_1bit FA11 (
		.a (A[11]),	.b (B[11]),	.cin (cout10),	.cout (cout11),	.s (Sum[11])
	);
	full_adder_1bit FA12 (
		.a (A[12]),	.b (B[12]),	.cin (cout11),	.cout (cout12),	.s (Sum[12])
	);
	full_adder_1bit FA13 (
		.a (A[13]),	.b(B[13]),	.cin (cout12),	.cout (cout13),	.s (Sum[13])
	);
	full_adder_1bit FA14 (
		.a (A[14]),	.b (B[14]),	.cin (cout13),	.cout (cout14),	.s (Sum[14])
	);
	full_adder_1bit FA15 (
		.a (A[15]),	.b (B[15]),	.cin (cout14),	.cout (Ovfl),	.s (Sum[15])
	);

endmodule