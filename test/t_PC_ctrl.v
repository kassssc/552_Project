//--------------------------------------------------------------------
// 
//--------------------------------------------------------------------
module t_pc_ctrl_4b;

	reg	[15:0] pc_in_test;
	reg [15:0] instr; // [ IIIIIIIII FFF CCC ]

	wire [15:0] pc_out;

	PC_control ctrl (
		.C(instr[11:9]), .I(instr[8:0]), .F(3'b000),
		.PC_in(pc_in_test[15:0]), .PC_out(pc_out[15:0]), .hlt(1'b0)
	);

	// Test Bench
	initial begin
		#50
		// Regular advance, pc_out = 
		// Jump by 0x10 = 0b00010000 pc_out = 0xCB10
		pc_in_test = 16'h0000;
		instr = 16'h0412;

	end
	
	// Print out values for confirmation
	initial begin
		//$monitor("a = %b\nb = %b\nc_in = %b\ng_out = %b\np_out = %b\ns = %b",
		//		  test[2], test[1], test[0], g_out, p_out, s);
		$monitor("pc_in = %h\ninstr = %h\npc_out = %h\n",
				  pc_in_test, instr, pc_out);
	end

endmodule