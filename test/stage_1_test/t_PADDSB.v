//--------------------------------------------------------------------
// TEST PADDSB
//--------------------------------------------------------------------

// PASSED PASSED PASSED PASSED PASSED PASSED PASSED PASSED PASSED
module t_SATADD_4b;

	reg	[7:0] test;
	wire [3:0] S;


 	SATADD_4b satadd (
		.A(test[7:4]), .B(test[3:0]), .S(S)
	);

	// Test Bench
	initial begin
		#50
		test = 8'b01011010;
		#50
		test = 8'b10001000;
		#50
		test = 8'b01110111;
		#50
		test = 8'b01000100;
		#50
		test = 8'b10101010;
	end
	
	// Print out values for confirmation
	initial begin
		//$monitor("a = %b\nb = %b\nc_in = %b\ng_out = %b\np_out = %b\ns = %b",
		//		  test[2], test[1], test[0], g_out, p_out, s);
		$monitor("A = %b\tB = %b\n\tS = %b\n",
				  test[7:4], test[3:0], S[3:0]);
	end

endmodule