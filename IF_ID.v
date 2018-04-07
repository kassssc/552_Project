module IF_ID(
	input [15:0]pc_new,
	input [15:0]instr_new,
	output [15:0]pc_current,
	output [15:0]instr_current,
	input wen,
	input rst
);

state_reg pc( 
	.pc_new(pc_new),
	.clk(clk),
	.rst(rst),
	.wen(wen),
	.pc_current(pc_current)
);
	
state_reg instr( 
	.pc_new(instr_new),
	.clk(clk),
	.rst(rst),
	.wen(wen),
	.pc_current(instr_current)
);

endmodule

