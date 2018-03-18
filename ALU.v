module ALU (clk, ALU_in1, ALU_in2, op, ALU_out, flag);

	input	[15:0]	ALU_in1, ALU_in2;
	input	[2:0]	op;
	output	[15:0]	ALU_out;
	output	[2:0]	flag;  //MSB is N, then Z, LSB is V [ N Z V ]

	wire	[15:0]	ADDSUB_out, SHIFTER_out, xor_out, red, paddsb;
	wire	xor_Z_flag;

	assign xor_out[15:0] = ALU_in1[15:0] ^ ALU_in2[15:0];
	assign xor_Z_flag = |xor_out? 1'b0 : 1'b1;

	CLA_16b addsub_16b (
		.A(ALU_in1[15:0]),		.B(ALU_in2[15:0]),	.sub(op[0]),
		.S(ADDSUB_out[15:0]),	.flag(flag[2:0])
	);

	SHIFTER_16b shifter_16b (
		.Shift_In(ALU_in1[15:0]),	.Shift_Val(ALU_in2[15:0]),
		.Mode(op[1:0]), 			.Shift_Out(SHIFTER_out[15:0])
	);

	RED_16b red_16b (
		.SrcData1(ALU_in1[15:0]), .SrcData2(ALU_in2[15:0]), .DesData(red)
	);

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