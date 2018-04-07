module EX_MEM(
	input regwrite_new,
	input memtoreg_new,
	input branch_new,
	input memwrite_new,
	input memread_new,
	input [15:0] addresult_new, 
	input [15:0] aluresult_new, 
	input [15:0] regread2_new,
	input zeroflag_new,
	input [3:0]muxout_new,
	input clk,
	input wen,
	input rst,
	output regwrite_current,
	output memtoreg_current,
	output branch_current,
	output memwrite_current,
	output memread_current,
	output [15:0] addresult_current, 
	output [15:0] aluresult_current, 
	output [15:0] regread2_current,
	output zeroflag_current,
	output [3:0]muxout_current
);

state_reg addresult(
	.state_new(addresult_new[15:0]),
	.state_curr(addresult_current[15:0]),
	.clk(clk),
	.rst(rst),
	.wen(wen)
);

state_reg aluresult(
	.state_new(aluresult_new[15:0]),
	.state_curr(aluresult_current[15:0]),
	.clk(clk),
	.rst(rst),
	.wen(wen)
);

state_reg regread2(
	.state_new(regread2_new[15:0]),
	.state_curr(regread2_current[15:0]),
	.clk(clk),
	.rst(rst),
	.wen(wen)
);

reg_4bit muxout(
	.reg_new(muxout_new[3:0]),	
	.clk(clk),
	.rst(rst),
	.wen(wen),
	.reg_current(muxout_current[3:0])
);

reg_1bit zeroflag(
	.reg_new(zeroflag_new),	
	.clk(clk),
	.rst(rst),
	.wen(wen),
	.reg_current(zeroflag_current)
);

wb wb( 
	.regwrite_new(regwrite_new),
	.memtoreg_new(memread_new),
	.wen(wen),
	.clk(clk),
	.rst(rst),
	.regwrite_current(regwrite_current),
	.memtoreg_current(memtoreg_current)
);

m mem(
	.branch_new(branch_new),
	.memwrite_new(memwrite_new),
	.memread_new(memread_new),
	.clk(clk),
	.rst(rst), 
	.wen(wen),
	.branch_current(branch_current),
	.memwrite_current(memwrite_current),
	.memread_current(memread_current)
);

endmodule

