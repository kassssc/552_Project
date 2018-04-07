module IF_ID(
	input [15:0]pc_new,
	input [15:0]instr_new,
	output [15:0]pc_current,
	output [15:0]instr_current,
	input clk,
	input rst,
	input wen
);

state_reg pc( 
	.pc_new(pc_new[15:0]),
	.pc_current(pc_current[15:0]),
	.clk(clk),
	.rst(rst),
	.wen(wen)
);
	
state_reg instr( 
	.pc_new(instr_new[15:0]),
	.pc_current(instr_current[15:0])
	.clk(clk),
	.rst(rst),
	.wen(wen),
	
);

endmodule

