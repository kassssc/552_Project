//--------------------------------------------------------------------
// TEST SHIFTER
//--------------------------------------------------------------------

//--------------------------------------------------------------------
// PASSED PASSED PASSED PASSED PASSED PASSED PASSED PASSED PASSED
//--------------------------------------------------------------------
module t_Shifter;

	reg		[15:0]	test;
	reg		[3:0]	shift_val;
	reg     [1:0]	mode;

	wire    [15:0]	shifted;

	Shifter_16b S (
		.Shift_In	(test[15:0]),
		.Shift_Out	(shifted[15:0]),
		.Shift_Val	(shift_val[3:0]),
		.Mode		(mode[1:0])
	);

	// Test Bench
	initial begin
		#50
		// TEST SLL, Mode = 00
		mode = 2'b00;
		#20
		test = 16'b1000100010001000;
		shift_val = 4'b0011;
		#20
		test = 16'b1111000011110000;
		shift_val = 4'b0100;
		#20
		test = 16'b0011001100110011;
		shift_val = 4'b0100;

		#50
		mode = 2'b01;
		// TEST SRA, Mode = 01
		#20
		test = 16'b1000100010001000;
		shift_val = 4'b0011;
		#20
		test = 16'b1111000011110000;
		shift_val = 4'b0100;
		#20
		test = 16'b0011001100110011;
		shift_val = 4'b0100;

		#50
		mode = 2'b10;
		// TEST ROR, Mode = 10
		test = 16'b1000100010001000;
		shift_val = 4'b0011;
		#20
		test = 16'b1111000011110000;
		shift_val = 4'b0100;
		#20
		test = 16'b0011001100110011;
		shift_val = 4'b0100;

		#20 $stop;
	end

	// Print out values for confirmation
	initial begin
		$monitor("Shift_In = %b\nShift Amount = %d\nResult = %b\n",
				  test[15:0], shift_val[3:0], shifted[15:0],);
	end

endmodule
