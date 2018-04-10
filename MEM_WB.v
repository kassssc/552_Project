module MEM_WB(
	input regwrite_new,
	input [15:0] reg_write_data_new, 
	input [3:0] reg_write_select_new,
	input clk,
	input wen,
	input rst,
	output regwrite_current,
	output [15:0] reg_write_data_current, 
	output [3:0] reg_write_select_current
);

state_reg reg_write_data(
	.state_new(reg_write_data_new[15:0]),
	.state_curr(reg_write_data_current[15:0]),
	.clk(clk),
	.rst(rst),
	.wen(wen)
);

dff reg_write_select_0(
	.state_new(reg_write_select_new[0]),
	.state_curr(reg_write_select_current[0]),
	.clk(clk),
	.rst(rst),
	.wen(wen)
);

dff reg_write_select_1(
	.state_new(reg_write_select_new[1]),
	.state_curr(reg_write_select_current[1]),
	.clk(clk),
	.rst(rst),
	.wen(wen)
);

dff reg_write_select_2(
	.state_new(reg_write_select_new[2]),
	.state_curr(reg_write_select_current[2]),
	.clk(clk),
	.rst(rst),
	.wen(wen)
);

dff reg_write_select_3(
	.state_new(reg_write_select_new[3]),
	.state_curr(reg_write_select_current[3]),
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

