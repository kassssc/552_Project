module ALU (ALU_in1, ALU_in2, op, ALU_out, flag, flag_write);

	input	[15:0]	ALU_in1, ALU_in2;
	input	[]
	input	[2:0]	op;
	output	[15:0]	ALU_out;
	output	[2:0]	flag, flag_write;	// [ N Z V ]

	wire	[15:0]	ADDSUB_out, SHIFTER_out, xor_out, red, paddsb;

	assign flag_write[0] = ~op[1] & ~op[0]; // Write V flag?
	assign flag_write[1] = 1'b1;			// Write Z flag?
	assign flag_write[2] = ~op[1] & ~op[0];	// Write N flag?

	assign flag[1] = ~(|ALU_out[15:0]);			// Set Z flag

	// OP
	// XOR: 011
	assign xor_out[15:0] = ALU_in1[15:0] ^ ALU_in2[15:0];

	// OP
	// ADD: 000
	// SUB: 001
	CLA_16b addsub_16b (
		.A(ALU_in1[15:0]),		.B(ALU_in2[15:0]),	.sub(op[0]),
		.S(ADDSUB_out[15:0]),	.ovfl(flag[0]),		.neg(flag[2])
	);

	// OP
	// SLL: 100
	// SRA: 101
	// ROR: 110
	SHIFTER_16b shifter_16b (
		.Shift_In(ALU_in1[15:0]),	.Shift_Val(ALU_in2[3:0]),
		.Mode(op[1:0]), 			.Shift_Out(SHIFTER_out[15:0])
	);

	// OP
	// RED: 010
	RED_16b red_16b (
		.SrcData1(ALU_in1[15:0]), .SrcData2(ALU_in2[15:0]), .DesData(red)
	);

	// OP
	// PADDSB: 111
	PADDSB_16b paddsb_16b (
		.A(ALU_in1[15:0]), .B(ALU_in2[15:0]), .S(paddsb[15:0])
	);

	MUX_81_16b sel_ALU_out (
		.sel(op[2:0]),
		.i0(ADDSUB_out[15:0]),
		.i1(ADDSUB_out[15:0]),
		.i2(red[15:0]),
		.i3(xor_out[15:0]),
		.i4(SHIFTER_out[15:0]),
		.i5(SHIFTER_out[15:0]),
		.i6(SHIFTER_out[15:0]),
		.i7(paddsb[15:0]),
		.out(ALU_out[15:0])
	);

endmodule // ALU