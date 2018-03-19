module PC_control(C, I, F, PC_in, PC_out, hlt, B, branch_reg_in);

	input hlt;
	input	[3:0]	B;	// branch instr
	input	[2:0]	C;	// Condition Encoding
	input	[2:0]	F;	// [ N V Z ]
	input	[8:0]	I;
	input	[15:0]	PC_in;
	input 	[15:0] 	branch_reg_in;
	output	[15:0]	PC_out;


	wire neg_flag, ovfl_flag, zero_flag, branch;
	wire NEQ, EQ, GT, LT, GEQ, LEQ, OVFL, UNCOND;
	wire [15:0] target, sign_extend_I, shifted_I, PC_plus_2, imm_target;


	wire is_branch_imm, is_branch_reg, branch_to_reg, branch_to_imm;

	assign is_branch_imm = B[3] & B[2] & ~B[1] & ~B[0];
	assign is_branch_reg = B[3] & B[2] & ~B[1] & B[0];

	assign branch_to_reg = branch & is_branch_reg;
	assign branch_to_imm = branch & is_branch_imm;

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

	assign sign_extend_I[15:0] = {{7{I[8]}}, (I[8:0])};
	assign shifted_I[15:0] = sign_extend_I[15:0] << 1;

	// PC_plus_2 = PC + 2
	CLA_16b PC_adder (
		.A(PC_in), .B(16'h0002), .sub(1'b0), .S(PC_plus_2), .ovfl(), .neg()
	);

	// Target = PC + 2 + (I << 1)
	CLA_16b target_adder (
		.A(PC_plus_2), .B(shifted_I), .sub(1'b0), .S(imm_target), .ovfl(), .neg()
	);

	assign PC_out = (hlt)? PC_in :
					(branch_to_imm)? imm_target :
					(branch_to_reg)? branch_reg_in : PC_plus_2;
					
endmodule