module flag_register(
	input [2:0]flag_new,
	input [2:0]wen,
	input clk,
	input rst,
	output [2:0]flag_current
);

dff PC_bit0(
	.d(flag_new[0]), 
	.q(flag_current[0]), 
	.wen(wen[0]), 
	.clk(clk), 
	.rst(rst)
);

dff PC_bit1(
	.d(flag_new[1]), 
	.q(flag_current[1]), 
	.wen(wen[1]), 
	.clk(clk), 
	.rst(rst)
);

dff PC_bit2(
	.d(flag_new[2]), 
	.q(flag_current[2]), 
	.wen(wen[2]), 
	.clk(clk), 
	.rst(rst)
);

endmodule