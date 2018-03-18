module flag_register(
	input [2:0]flag_new,
	input [2:0]wen,
	input clk,
	input rst,
	output [2:0]flag_current
)

dff PC_bit0(
	.q(PC_new[0]), 
	.d(PC_current[0]), 
	.wen(wen[0]), 
	.clk(clk), 
	.rst(rst_n)
);

dff PC_bit1(
	.q(PC_new[1]), 
	.d(PC_current[1]), 
	.wen(wen[1]), 
	.clk(clk), 
	.rst(rst_n)
);

dff PC_bit2(
	.q(PC_new[2]), 
	.d(PC_current[2]), 
	.wen(wen[2]), 
	.clk(clk), 
	.rst(rst_n)
);