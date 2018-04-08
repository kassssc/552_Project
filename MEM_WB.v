module MEM_WB(
	input regwrite_new,
	input [15:0] reg_write_data_new, 
	input [15:0] reg_write_select_new,
	input clk,
	input wen,
	input rst,
	output regwrite_current,
	output [15:0] reg_write_data_current, 
	output [15:0] reg_write_data_current, 
);

state_reg aluresult(
	.state_new(aluresult_new[15:0]),
	.state_curr(aluresult_current[15:0]),
	.clk(clk),
	.rst(rst),
	.wen(wen)
);

state_reg dataread(
	.state_new(dataread_new[15:0]),
	.state_curr(dataread_current[15:0]),
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

wb wb( 
	.regwrite_new(regwrite_new),
	.memtoreg_new(memread_new),
	.wen(wen),
	.clk(clk),
	.rst(rst),
	.regwrite_current(regwrite_current),
	.memtoreg_current(memtoreg_current)
);

endmodule

