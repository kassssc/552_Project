module m(
	input memwrite_new,
	input clk,
	input rst, 
	input wen,
	output memwrite_current
);

dff memwrite(
	.instr_new(memwrite_new),
	.instr_current(memwrite_current),
	.clk(clk),
	.rst(rst),
	.wen(wen)
);


endmodule