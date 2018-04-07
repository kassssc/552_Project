module reg_4bit(
	input [3:0]reg_new,	
	input wen,
	input clk,
	input rst,
	output [3:0]reg_current
);

dff b0(
	.d(reg_new[0]), 
	.q(reg_current[0]), 
	.wen(wen), 
	.clk(clk), 
	.rst(rst)
);

dff b1(
	.d(reg_new[1]), 
	.q(reg_current[1]), 
	.wen(wen), 
	.clk(clk), 
	.rst(rst)
);

dff b2(
	.d(reg_new[2]), 
	.q(reg_current[2]), 
	.wen(wen), 
	.clk(clk), 
	.rst(rst)
);

dff b3(
	.d(reg_new[3]), 
	.q(reg_current[3]), 
	.wen(wen), 
	.clk(clk), 
	.rst(rst)
);

endmodule
