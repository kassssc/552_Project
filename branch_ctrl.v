module BRANCH_CTRL (
	input [15:0]pc_plus_2,
	input BranchImm,
	input BranchReg,
	input [8:0]imm,
	input [2:0]cc,
	input [2:0]flag,
	input [15:0]branch_reg_data,
	output BranchOut,
	output [15:0]pc_out
);

	wire neg_flag, ovfl_flag, zero_flag, branch;
	wire NEQ, EQ, GT, LT, GEQ, LEQ, OVFL, UNCOND;
	wire [15:0] sign_extend_imm, shifted_imm, PC_plus_2, imm_target;

	assign neg_flag = flag[2];
	assign ovfl_flag = flag[0];
	assign zero_flag = flag[1];

	assign NEQ    = ~cc[2] & ~cc[1] & ~cc[0];
	assign EQ     = ~cc[2] & ~cc[1] &  cc[0];
	assign GT     = ~cc[2] &  cc[1] & ~cc[0];
	assign LT     = ~cc[2] &  cc[1] &  cc[0];
	assign GEQ    =  cc[2] & ~cc[1] & ~cc[0];
	assign LEQ    =  cc[2] & ~cc[1] &  cc[0];
	assign OVFL   =  cc[2] &  cc[1] & ~cc[0];
	assign UNCOND =  cc[2] &  cc[1] &  cc[0];

	assign Branch = ( (NEQ & ~zero_flag) |
					  (EQ & zero_flag) |
					  (GT & ~zero_flag & ~neg_flag) |
					  (LT & neg_flag) |
					  (GEQ & (zero_flag | (~zero_flag & ~neg_flag))) |
					  (LEQ & (zero_flag | neg_flag)) |
					  (OVFL & ovfl_flag) |
					  UNCOND
					);

	assign sign_extend_imm[15:0] = {{7{imm[8]}}, (imm[8:0])};
	assign shifted_imm[15:0] = sign_extend_imm[15:0] << 1;

	// Target = PC + 2 + (I << 1)
	CLA_16b target_adder (
		.A(pc_plus_2[15:0]), .B(shifted_imm[15:0]),
		.sub(1'b0), .S(imm_target), .ovfl(), .neg()
	);

	assign pc_out = (Branch & BranchImm)? imm_target[15:0] :
					(Branch & BranchReg)? branch_reg_data[15:0] : pc_plus_2[15:0];

	assign BranchOut = Branch & (BranchImm | BranchReg);

endmodule