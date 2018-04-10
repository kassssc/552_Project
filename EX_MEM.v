module EX_MEM(
	input regwrite_new,
	input memtoreg_new,
	input memwrite_new,
	input [15:0] mem_addr_new,
	input [15:0] reg_write_data_new,
	input [15:0] alu_source_2_new,
	input [3:0] reg_write_select_new,
	input clk,
	input wen,
	input rst,
	output regwrite_current,
	output memtoreg_current,
	output memwrite_current,
	output [15:0] mem_addr_current,
	output [15:0] alu_source_2_current,
	output [15:0] reg_write_data_current,
	output [3:0] reg_write_select_current
);

state_reg mem_addr(
	.state_new(mem_addr_new[15:0]),
	.state_current(mem_addr_current[15:0]),
	.clk(clk),
	.rst(rst),
	.wen(wen)
);

state_reg alu_source_2(
	.state_new(alu_source_2_new[15:0]),
	.state_current(alu_source_2_current[15:0]),
	.clk(clk),
	.rst(rst),
	.wen(wen)
);

state_reg reg_write_data(
	.state_new(reg_write_data_new[15:0]),
	.state_current(reg_write_data_current[15:0]),
	.clk(clk),
	.rst(rst),
	.wen(wen)
);

reg_4bit reg_write_select(
	.reg_new(reg_write_select_new[3:0]),
	.clk(clk),
	.rst(rst),
	.wen(wen),
	.reg_current(reg_write_select_current[3:0])
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

endmodule

