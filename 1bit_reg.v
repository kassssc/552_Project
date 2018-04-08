module reg_1bit(
	input reg_new,
	input wen,
	input clk,
	input rst,
	output reg_current
);

dff b0(
	.d(reg_new),
	.q(reg_current),
	.wen(wen),
	.clk(clk),
	.rst(rst)
);

endmodule
