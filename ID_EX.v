module ID_EX(
	input [15:0]pc_new, 
	input [15:0]data1_new,
	input [15:0]data2_new,
	input [15:0]instr_new,
	input regwrite_new,
	input [3:0]reg_write_select_new,
	input memtoreg_new,
	input memwrite_new,
	input clk,
	input rst,
	input wen,
	output [15:0]pc_current,
	output [15:0]data1_current,
	output [15:0]data2_current,
	output [15:0]instr_current,
	output regwrite_current,
	output [3:0]reg_write_select_current,
	output memtoreg_current,
	output memwrite_current
);

state_reg pc( 
	.pc_new(pc_new[15:0]),
	.pc_current(pc_current[15:0]),
	.clk(clk),
	.rst(rst),
	.wen(wen)
);
	
state_reg data1(
	.data1_new(data1_new[15:0]),
	.data1_current(data1_current[15:0]),
	.clk(clk),
	.rst(rst),
	.wen(wen)
);

state_reg data2(
	.data2_new(data2_new[15:0]),
	.data2_current(data2_current[15:0]),
	.clk(clk),
	.rst(rst),
	.wen(wen)
);

state_reg instr(
	.instr_new(instr_new[15:0]),
	.instr_current(instr_current[15:0]),
	.clk(clk),
	.rst(rst),
	.wen(wen)
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
	.memwrite_new(memwrite_new),
	.clk(clk),
	.rst(rst), 
	.wen(wen),
	.memwrite_current(memwrite_current)
);

ex ex(
	.aluop_new(aluop_new),
	.regdst_new(regdst_new),
	.clk(clk),
	.rst(rst), 
	.wen(wen),
	.aluop_current(aluop_current),
	.regdst_current(regdst_current)
);

endmodule
