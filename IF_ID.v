module IF_ID(
	input [15:0]pc_plus_4_new,
	input [15:0]instr_new,
	input clk,
	input rst,
	input wen,
	output [15:0]pc_plus_4_curr,
	output [15:0]instr_curr
);

state_reg pc(
	.state_new(pc_plus_4_new[15:0]),
	.state_curr(pc_plus_4_curr[15:0]),
	.clk(clk),
	.rst(rst),
	.wen(wen)
);

state_reg instr(
	.state_new(instr_new[15:0]),
	.state_curr(instr_curr[15:0]),
	.clk(clk),
	.rst(rst),
	.wen(wen)
);

endmodule

