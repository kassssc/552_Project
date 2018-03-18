//--------------------------------------------------------------------
// TEST CLA
//--------------------------------------------------------------------

// PASSED PASSED PASSED PASSED PASSED PASSED PASSED PASSED PASSED
module t_CLA_1b;

	reg	[2:0] test;

	wire g_out, p_out, s;


 	CLA_1b cla1 (
		.a(test[2]), .b(test[1]), .c_in(test[0]), .g_out(g_out), .p_out(p_out), .s(s)
	);

	// Test Bench
	initial begin
		#20
		test = 3'b000;
		#20
		test = 3'b001;
		#20
		test = 3'b010;
		#20
		test = 3'b011;
		#20
		test = 3'b100;
		#20
		test = 3'b101;
		#20
		test = 3'b110;
		#20
		test = 3'b111;

	end
	
	// Print out values for confirmation
	initial begin
		//$monitor("a = %b\nb = %b\nc_in = %b\ng_out = %b\np_out = %b\ns = %b",
		//		  test[2], test[1], test[0], g_out, p_out, s);
		$monitor("abc = %b%b%b\ng p s = %b%b%b\n",
				  test[2], test[1], test[0], g_out, p_out, s);
	end

endmodule

// PASSED PASSED PASSED PASSED PASSED PASSED PASSED PASSED PASSED
module t_CLA_4b;

	reg	[8:0] test;

	wire [3:0] s;
	wire g_out, p_out;


	CLA_4b cla4 (
		.a(test[7:4]), .b(test[3:0]), .c_in(test[8]), .gg_out(g_out), .pg_out(p_out), .s(s)
	);

	// Test Bench
	initial begin
		#20
		test = 9'b000000100;
		#20
		test = 9'b010101000;
		#20
		test = 9'b001110010;

	end
	
	// Print out values for confirmation
	initial begin
		//$monitor("a = %b\nb = %b\nc_in = %b\ng_out = %b\np_out = %b\ns = %b",
		//		  test[2], test[1], test[0], g_out, p_out, s);
		$monitor("abc = %b %b %b\ng p s = %b %b %b\n",
				  test[7:4], test[3:0], test[8], g_out, p_out, s[3:0]);
	end

endmodule

module t_CLA_16b;

	reg		[15:0] t_A, t_B;
	reg		t_sub;

	wire	[15:0]	S;
	wire	[2:0]	F;


 	CLA_16b CLA (
 		.A(t_A),
 		.B(t_B),
 		.sub(t_sub),
 		.S(S),
 		.flag(F)
 	);

	// Test Bench
	initial begin
		#20
		t_A = 16'h7FFF;
		t_B = 16'h0010;
		t_sub = 1'b0;

		#20
		t_A = 16'h800A;
		t_B = 16'h80FF;
		t_sub = 1'b0;

	end
	
	// Print out values for confirmation
	initial begin
		$monitor("A = %b\nB = %b\nsub = %b\nS = %b\nflag = %b\n",
				  t_A, t_B, t_sub, S, F);
	end

endmodule