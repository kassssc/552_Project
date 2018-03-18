module PC_control(C, I, F, PC_in, PC_out, hlt);

	input hlt;
	input	[2:0]	C;	// Condition Encoding
	input	[2:0]	F;	// [ N V Z ]
	input	[8:0]	I;
	input	[15:0]	PC_in;
	output	[15:0]	PC_out;

	wire neg_flag, ovfl_flag, zero_flag, branch;
	wire NEQ, EQ, GT, LT, GEQ, LEQ, OVFL, UNCOND;
	wire [15:0] target, shifted_I, PC_plus_2;

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

	// PC_plus_2 = PC + 2
	CLA_16b PC_adder (
		.A(PC_in), .B(16'h0002), .sub(1'b0), .S(PC_plus_2), .ovfl(), .neg()
	);

	// Target = PC + 2 + (I << 1)
	CLA_16b target_adder (
		.A(PC_plus_2), .B(shifted_I), .sub(1'b0), .S(target), .ovfl(), .neg()
	);

	assign PC_out = (hlt)? PC_in : (branch)? target : PC_plus_2;

endmodule