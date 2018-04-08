module wb(
	input regwrite_new,
	input memtoreg_new,
	input wen,
	input clk,
	input rst,
	output regwrite_current,
	output memtoreg_current
);

dff regwrite(
	.d(regwrite_new), 
	.q(regwrite_current), 
	.wen(wen), 
	.clk(clk), 
	.rst(rst)
);

dff memtoreg(
	.d(memtoreg_new), 
	.q(memtoreg_current), 
	.wen(wen), 
	.clk(clk), 
	.rst(rst)
);

endmodule
