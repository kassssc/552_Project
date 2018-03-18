//--------------------------------------------------------------------
// 
//--------------------------------------------------------------------
module t_pc_ctrl_4b;

	reg	[15:0] pc_in_test;
	reg [14:0] others_test; // [ IIIIIIIII FFF CCC ]

	wire [15:0] pc_out;

	PC_control ctrl (
		.C(others_test[2:0]), .I(others_test[14:6]), .F(others_test[5:3]),
		.PC_in(pc_in_test[15:0]), .PC_out(pc_out[15:0]), .hlt(1'b0)
	);

	// Test Bench
	initial begin
		#50
		// Regular advance, pc_out = 0xDEAF
		pc_in_test = 16'hDEAD;
		others_test = 15'b000000000000000;
		#50
		// Regular Advance, pc_out = 0xBEF1
		pc_in_test = 16'hBEEF;
		others_test = 15'b000000000000000;
		#50
		// Jump by 0x10 = 0b00010000 pc_out = 0xCB10
		pc_in_test = 16'hC000;
		others_test = 15'b000001000000111;

	end
	
	// Print out values for confirmation
	initial begin
		//$monitor("a = %b\nb = %b\nc_in = %b\ng_out = %b\np_out = %b\ns = %b",
		//		  test[2], test[1], test[0], g_out, p_out, s);
		$monitor("pc_in = %h\nbranch = %b\npc_out = %h\n",
				  pc_in_test, others_test[14:6], pc_out);
	end

endmodule