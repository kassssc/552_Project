//--------------------------------------------------------------------
// TEST CLA
//--------------------------------------------------------------------

module t_CLA;

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