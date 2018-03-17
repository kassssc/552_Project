module ALU (ALU_in1, ALU_out2, op, ALU_out, flag);

	input	[15:0]	ALU_in1, ALU_out2;
	input	[2:0]	op;
	output	[15:0]	ALU_out;
	output	[2:0]	flag;

	