module IF_ID(
	input [15:0]pc_plus_2_new,
	input [15:0]instr_new,
	input clk,
	input rst,
	input wen,
	output [15:0]pc_plus_2_current,
	output [15:0]instr_current
);

state_reg pc(
	.state_new(pc_plus_2_new[15:0]),
	.clk(clk),
	.rst(rst),
	.wen(wen),
	.state_current(pc_plus_2_current[15:0])
);

state_reg instr(
	.state_new(instr_new[15:0]),
	.clk(clk),
	.rst(rst),
	.wen(wen),
	.state_current(instr_current[15:0])
);

endmodule

