module ID_EX(
	input [15:0]pc_new, 
	input [15:0]data1_new,
	input [15:0]data2_new,
	input [15:0]instr_new,
	input clk,
	input rst,
	input wen,
	output [15:0]pc_current,
	output [15:0]data1_current,
	output [15:0]data2_current,
	output [15:0]instr_current
)

state_reg pc( 
	.pc_new(pc_new[15:0]),
	.pc_current(pc_current[15:0]),
	.clk(clk),
	.rst(rst),
	.wen(wen)
);
	
state_reg data1(
	.data1_new(data1_new),
	.data1_current(data1_current),
	.clk(clk),
	.rst(rst),
	.wen(wen)
);

state_reg data2(
	.data2_new(data2_new),
	.data2_current(data2_current)
	.clk(clk),
	.rst(rst),
	.wen(wen)
);

state_reg instr(
	.instr_new(instr_new),
	.instr_current(instr_current),
	.clk(clk),
	.rst(rst),
	.wen(wen)
);

endmodule
