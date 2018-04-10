//--------------------------------------------------------------------
// 
//--------------------------------------------------------------------
module t_pc_ctrl_4b;

	reg	[15:0] pc_in_test;
	reg [15:0] instr, register; // [ IIIIIIIII FFF CCC ]

	wire [15:0] pc_out;
	wire is_branch_imm, is_branch_reg, branch;
	wire[15:0] target, PC_plus_2;

	PC_control ctrl (
		.C(instr[11:9]), .I(instr[8:0]), .F(3'b000),
		.PC_in(pc_in_test[15:0]), .PC_out(pc_out[15:0]), .hlt(1'b0), .branch_reg_in(register), .B(instr[15:12])
	);

	assign is_branch_imm = ctrl.is_branch_imm;
	assign is_branch_reg = ctrl.is_branch_reg;
	assign branch = ctrl.branch;
	assign target = ctrl.imm_target;
	assign PC_plus_2 = ctrl.PC_plus_2;

	// Test Bench
	initial begin
		
		// Regular advance, pc_out = 
		// Jump by 0x10 = 0b00010000 pc_out = 0xCB10
		register = 16'h0011;
		pc_in_test = 16'h0000;
		instr = 16'h0412;
		#50

		

		$display("b_imm:%b\nb_reg:%b\nb:%b\ntarget:%h\nplus2:%h\n",is_branch_imm, is_branch_reg, branch, target, PC_plus_2);
	
	// Print out values for confirmation

		//$monitor("a = %b\nb = %b\nc_in = %b\ng_out = %b\np_out = %b\ns = %b",
		//		  test[2], test[1], test[0], g_out, p_out, s);
		$monitor("pc_in = %h\ninstr = %h\npc_out = %h\n",
				  pc_in_test, instr, pc_out);
	end

endmodule