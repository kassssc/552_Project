module m(
	input branch_new,
	input memwrite_new,
	input memread_new,
	input clk,
	input rst, 
	input wen,
	output branch_current,
	output memwrite_current,
	output memread_current
);

dff branch(
	.instr_new(branch_new),
	.instr_current(branch_current),
	.clk(clk),
	.rst(rst),
	.wen(wen)
);

dff memwrite(
	.instr_new(memwrite_new),
	.instr_current(memwrite_current),
	.clk(clk),
	.rst(rst),
	.wen(wen)
);

dff memread(
	.instr_new(memread_new),
	.instr_current(memread_current),
	.clk(clk),
	.rst(rst),
	.wen(wen)
);

endmodule