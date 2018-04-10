module m(
	input memwrite_new,
	input clk,
	input rst,
	input wen,
	output memwrite_current
);

dff memwrite(
	.d(memwrite_new),
	.q(memwrite_current),
	.clk(clk),
	.rst(rst),
	.wen(wen)
);


endmodule