module MEM_WB(
	input regwrite_new,
	input [15:0] reg_write_data_new, 
	input [15:0] reg_write_select_new,
	input clk,
	input wen,
	input rst,
	output regwrite_current,
	output [15:0] reg_write_data_current, 
	output [15:0] reg_write_select_current
);

state_reg reg_write_data(
	.state_new(reg_write_data_new[15:0]),
	.state_curr(reg_write_data_current[15:0]),
	.clk(clk),
	.rst(rst),
	.wen(wen)
);

state_reg reg_write_select(
	.state_new(reg_write_select_new[15:0]),
	.state_curr(reg_write_select_current[15:0]),
	.clk(clk),
	.rst(rst),
	.wen(wen)
);

wb wb( 
	.regwrite_new(regwrite_new),
	.memtoreg_new(regwrite_new),
	.wen(wen),
	.clk(clk),
	.rst(rst),
	.regwrite_current(regwrite_current),
	.memtoreg_current()
);

endmodule

