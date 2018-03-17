module PC_control(C, I, F, PC_in, PC_out);

	input	[2:0]	C;	// Condition Encoding
	input	[2:0]	F;	// [ N V Z ]
	input	[8:0]	I;
	input	[15:0]	PC_in;
	output	[15:0]	PC_out;

	wire neg_flag, ovfl_flag, zero_flag, branch;
	wire NEQ, EQ, GT, LT, GEQ, LEQ, OVFL, UNCOND;
	wire [15:0] target, sign_extend_I, shifted_I, PC_plus_2;
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

	// Sign Extend I for computations
	assign sign_extend_I[8:0] = I[8:0];
	assign sign_extend_I[15:9] = {7{I[8]}};

	// I << 1
	Shifter S (
		.Shift_Out(shifted_I),	.Shift_In(sign_extend_I),
		.Shift_Val(4'b0001),	.Mode(1'b0)
	);

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

module add_4bit (Sum, Ovfl, A, B);

	input [3:0] A, B; 	// Input values
	output [3:0] Sum; 	// sum output
	output Ovfl; 		// To indicate overflow

	wire cout0, cout1, cout2;

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
		.a (A[3]),	.b (B[3]),	.cin (cout2),	.cout (Ovfl),	.s (Sum[3])
	);

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

module Shifter (Shift_Out, Shift_In, Shift_Val, Mode);

	input	[15:0] Shift_In;	// Number to perform shift operation on
	input	[3:0] Shift_Val;	// Shift amount (used to shift the 'Shift_In')
	input	Mode;				// Mode = 0: SLL,	Mode = 1: SRA
	output	[15:0] Shift_Out;	// Shifter value

	wire [15:0] shift1, shift2, shift4, shift8;
	wire [15:0] level1_out, level2_out, level4_out;

	//
	// First Level Shift (1-bit)
	//
	mux_21_1b m1_0 (
		.sel(Mode),	.i0(1'b0),			.i1(Shift_In[1]),	.out(shift1[0])
	);
	mux_21_1b m1_1 (
		.sel(Mode),	.i0(Shift_In[0]),	.i1(Shift_In[2]),	.out(shift1[1])
	);
	mux_21_1b m1_2 (
		.sel(Mode),	.i0(Shift_In[1]),	.i1(Shift_In[3]),	.out(shift1[2])
	);
	mux_21_1b m1_3 (
		.sel(Mode),	.i0(Shift_In[2]),	.i1(Shift_In[4]),	.out(shift1[3])
	);
	mux_21_1b m1_4 (
		.sel(Mode),	.i0(Shift_In[3]),	.i1(Shift_In[5]),	.out(shift1[4])
	);
	mux_21_1b m1_5 (
		.sel(Mode),	.i0(Shift_In[4]),	.i1(Shift_In[6]),	.out(shift1[5])
	);
	mux_21_1b m1_6 (
		.sel(Mode),	.i0(Shift_In[5]),	.i1(Shift_In[7]),	.out(shift1[6])
	);
	mux_21_1b m1_7 (
		.sel(Mode),	.i0(Shift_In[6]),	.i1(Shift_In[8]),	.out(shift1[7])
	);
	mux_21_1b m1_8 (
		.sel(Mode),	.i0(Shift_In[7]),	.i1(Shift_In[9]),	.out(shift1[8])
	);
	mux_21_1b m1_9 (
		.sel(Mode),	.i0(Shift_In[8]),	.i1(Shift_In[10]),	.out(shift1[9])
	);
	mux_21_1b m1_10 (
		.sel(Mode),	.i0(Shift_In[9]),	.i1(Shift_In[11]),	.out(shift1[10])
	);
	mux_21_1b m1_11 (
		.sel(Mode),	.i0(Shift_In[10]),	.i1(Shift_In[12]),	.out(shift1[11])
	);
	mux_21_1b m1_12 (
		.sel(Mode),	.i0(Shift_In[11]),	.i1(Shift_In[13]),	.out(shift1[12])
	);
	mux_21_1b m1_13 (
		.sel(Mode),	.i0(Shift_In[12]),	.i1(Shift_In[14]),	.out(shift1[13])
	);
	mux_21_1b m1_14 (
		.sel(Mode),	.i0(Shift_In[13]),	.i1(Shift_In[15]),	.out(shift1[14])
	);
	mux_21_1b m1_15 (
		.sel(Mode),	.i0(Shift_In[14]),	.i1(Shift_In[15]),	.out(shift1[15])
	);

	//
	// Select shift 1-bit or not
	//
	mux_21_16b sel_shift1 (
		.sel	(Shift_Val[0]),		// Shift 1-bit?
		.i0		(Shift_In[15:0]),	// No 1-bit shift
		.i1		(shift1[15:0]),		// 1-bit shifted
		.out	(level1_out[15:0])	// Input for next stage shift
	);

	//
	// Second Level Shift (2-bit)
	//
	mux_21_1b m2_0 (
		.sel(Mode),	.i0(1'b0),				.i1(level1_out[2]),		.out(shift2[0])
	);
	mux_21_1b m2_1 (
		.sel(Mode),	.i0(1'b0),				.i1(level1_out[3]),		.out(shift2[1])
	);
	mux_21_1b m2_2 (
		.sel(Mode),	.i0(level1_out[0]),		.i1(level1_out[4]),		.out(shift2[2])
	);
	mux_21_1b m2_3 (
		.sel(Mode),	.i0(level1_out[1]),		.i1(level1_out[5]),		.out(shift2[3])
	);
	mux_21_1b m2_4 (
		.sel(Mode),	.i0(level1_out[2]),		.i1(level1_out[6]),		.out(shift2[4])
	);
	mux_21_1b m2_5 (
		.sel(Mode),	.i0(level1_out[3]),		.i1(level1_out[7]),		.out(shift2[5])
	);
	mux_21_1b m2_6 (
		.sel(Mode),	.i0(level1_out[4]),		.i1(level1_out[8]),		.out(shift2[6])
	);
	mux_21_1b m2_7 (
		.sel(Mode),	.i0(level1_out[5]),		.i1(level1_out[9]),		.out(shift2[7])
	);
	mux_21_1b m2_8 (
		.sel(Mode),	.i0(level1_out[6]),		.i1(level1_out[10]),	.out(shift2[8])
	);
	mux_21_1b m2_9 (
		.sel(Mode),	.i0(level1_out[7]),		.i1(level1_out[11]),	.out(shift2[9])
	);
	mux_21_1b m2_10 (
		.sel(Mode),	.i0(level1_out[8]),		.i1(level1_out[12]),	.out(shift2[10])
	);
	mux_21_1b m2_11 (
		.sel(Mode),	.i0(level1_out[9]),		.i1(level1_out[13]),	.out(shift2[11])
	);
	mux_21_1b m2_12 (
		.sel(Mode),	.i0(level1_out[10]),	.i1(level1_out[14]),	.out(shift2[12])
	);
	mux_21_1b m2_13 (
		.sel(Mode),	.i0(level1_out[11]),	.i1(level1_out[15]),	.out(shift2[13])
	);
	mux_21_1b m2_14 (
		.sel(Mode),	.i0(level1_out[12]),	.i1(level1_out[15]),	.out(shift2[14])
	);
	mux_21_1b m2_15 (
		.sel(Mode),	.i0(level1_out[13]),	.i1(level1_out[15]),	.out(shift2[15])
	);

	//
	// Select shift 2-bit or not
	//
	mux_21_16b sel_shift2 (
		.sel	(Shift_Val[1]),		// Shift 2-bit?
		.i0		(level1_out[15:0]),	// No 2-bit shift
		.i1		(shift2[15:0]),		// 2-bit shifted
		.out	(level2_out[15:0])	// Input for next stage shift
	);

	//
	// Third Level Shift (4-bit)
	//
	mux_21_1b m3_0 (
		.sel(Mode),	.i0(1'b0),				.i1(level2_out[4]),		.out(shift4[0])
	);
	mux_21_1b m3_1 (
		.sel(Mode),	.i0(1'b0),				.i1(level2_out[5]),		.out(shift4[1])
	);
	mux_21_1b m3_2 (
		.sel(Mode),	.i0(1'b0),				.i1(level2_out[6]),		.out(shift4[2])
	);
	mux_21_1b m3_3 (
		.sel(Mode),	.i0(1'b0),				.i1(level2_out[7]),		.out(shift4[3])
	);
	mux_21_1b m3_4 (
		.sel(Mode),	.i0(level2_out[0]),		.i1(level2_out[8]),		.out(shift4[4])
	);
	mux_21_1b m3_5 (
		.sel(Mode),	.i0(level2_out[1]),		.i1(level2_out[9]),		.out(shift4[5])
	);
	mux_21_1b m3_6 (
		.sel(Mode),	.i0(level2_out[2]),		.i1(level2_out[10]),	.out(shift4[6])
	);
	mux_21_1b m3_7 (
		.sel(Mode),	.i0(level2_out[3]),		.i1(level2_out[11]),	.out(shift4[7])
	);
	mux_21_1b m3_8 (
		.sel(Mode),	.i0(level2_out[4]),		.i1(level2_out[12]),	.out(shift4[8])
	);
	mux_21_1b m3_9 (
		.sel(Mode),	.i0(level2_out[5]),		.i1(level2_out[13]),	.out(shift4[9])
	);
	mux_21_1b m3_10 (
		.sel(Mode),	.i0(level2_out[6]),		.i1(level2_out[14]),	.out(shift4[10])
	);
	mux_21_1b m3_11 (
		.sel(Mode),	.i0(level2_out[7]),		.i1(level2_out[15]),	.out(shift4[11])
	);
	mux_21_1b m3_12 (
		.sel(Mode),	.i0(level2_out[8]),		.i1(level2_out[15]),	.out(shift4[12])
	);
	mux_21_1b m3_13 (
		.sel(Mode),	.i0(level2_out[9]),		.i1(level2_out[15]),	.out(shift4[13])
	);
	mux_21_1b m3_14 (
		.sel(Mode),	.i0(level2_out[10]),	.i1(level2_out[15]),	.out(shift4[14])
	);
	mux_21_1b m3_15 (
		.sel(Mode),	.i0(level2_out[11]),	.i1(level2_out[15]),	.out(shift4[15])
	);

	//
	// Select shift 4-bit or not
	//
	mux_21_16b sel_shift4 (
		.sel	(Shift_Val[2]),		// Shift 4-bit?
		.i0		(level2_out[15:0]),	// No 4-bit shift
		.i1		(shift4[15:0]),		// 4-bit shifted
		.out	(level4_out[15:0])	// Input for next stage shift
	);

	//
	// Fourth Level Shift (8-bit)
	//
	mux_21_1b m4_0 (
		.sel(Mode),	.i0(1'b0),				.i1(level4_out[8]),		.out(shift8[0])
	);
	mux_21_1b m4_1 (
		.sel(Mode),	.i0(1'b0),				.i1(level4_out[9]),		.out(shift8[1])
	);
	mux_21_1b m4_2 (
		.sel(Mode),	.i0(1'b0),				.i1(level4_out[10]),	.out(shift8[2])
	);
	mux_21_1b m4_3 (
		.sel(Mode),	.i0(1'b0),				.i1(level4_out[11]),	.out(shift8[3])
	);
	mux_21_1b m4_4 (
		.sel(Mode),	.i0(1'b0),				.i1(level4_out[12]),	.out(shift8[4])
	);
	mux_21_1b m4_5 (
		.sel(Mode),	.i0(1'b0),				.i1(level4_out[13]),	.out(shift8[5])
	);
	mux_21_1b m4_6 (
		.sel(Mode),	.i0(1'b0),				.i1(level4_out[14]),	.out(shift8[6])
	);
	mux_21_1b m4_7 (
		.sel(Mode),	.i0(1'b0),				.i1(level4_out[15]),	.out(shift8[7])
	);
	mux_21_1b m4_8 (
		.sel(Mode),	.i0(level4_out[0]),		.i1(level4_out[15]),	.out(shift8[8])
	);
	mux_21_1b m4_9 (
		.sel(Mode),	.i0(level4_out[1]),		.i1(level4_out[15]),	.out(shift8[9])
	);
	mux_21_1b m4_10 (
		.sel(Mode),	.i0(level4_out[2]),		.i1(level4_out[15]),	.out(shift8[10])
	);
	mux_21_1b m4_11 (
		.sel(Mode),	.i0(level4_out[3]),		.i1(level4_out[15]),	.out(shift8[11])
	);
	mux_21_1b m4_12 (
		.sel(Mode),	.i0(level4_out[4]),		.i1(level4_out[15]),	.out(shift8[12])
	);
	mux_21_1b m4_13 (
		.sel(Mode),	.i0(level4_out[5]),		.i1(level4_out[15]),	.out(shift8[13])
	);
	mux_21_1b m4_14 (
		.sel(Mode),	.i0(level4_out[6]),		.i1(level4_out[15]),	.out(shift8[14])
	);
	mux_21_1b m4_15 (
		.sel(Mode),	.i0(level4_out[7]),		.i1(level4_out[15]),	.out(shift8[15])
	);

	//
	// Select shift 8-bit or not
	//
	mux_21_16b sel_shift8 (
		.sel	(Shift_Val[3]),		// Shift 8-bit?
		.i0		(level4_out[15:0]),	// No 8-bit shift
		.i1		(shift8[15:0]),		// 8-bit shifted
		.out	(Shift_Out[15:0])	// Final Shifted Value
	);

endmodule

module mux_21_1b (sel, i0, i1, out);
	input	sel, i0, i1;
	output	out;
	reg		out;

	always @(*)
	case (sel)
		1'b0: out = i0;
		1'b1: out = i1;
	endcase
endmodule

module mux_21_16b (sel, i0, i1, out);
	input	sel;
	input	[15:0]	i0, i1;
	output	[15:0]	out;
	reg		[15:0]	out;

	always @(*)
	case (sel)
		1'b0: out = i0;
		1'b1: out = i1;
	endcase
endmodule
