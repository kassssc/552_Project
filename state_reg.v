module state_reg(
	input [15:0] state_new,
	input clk,
	input rst,
	input wen,
	output [15:0] state_current
);

dff bit0(
	.d(state_new[0]),
	.q(state_current[0]),
	.wen(wen),
	.clk(clk),
	.rst(rst)
);

dff bit1(
	.d(state_new[1]),
	.q(state_current[1]),
	.wen(wen),
	.clk(clk),
	.rst(rst)
);

dff bit2(
	.d(state_new[2]),
	.q(state_current[2]),
	.wen(wen),
	.clk(clk),
	.rst(rst)
);

dff bit3(
	.d(state_new[3]),
	.q(state_current[3]),
	.wen(wen),
	.clk(clk),
	.rst(rst)
);

dff bit4(
	.d(state_new[4]),
	.q(state_current[4]),
	.wen(wen),
	.clk(clk),
	.rst(rst)
);

dff bit5(
	.d(state_new[5]),
	.q(state_current[5]),
	.wen(wen),
	.clk(clk),
	.rst(rst)
);

dff bit6(
	.d(state_new[6]),
	.q(state_current[6]),
	.wen(wen),
	.clk(clk),
	.rst(rst)
);


dff bit7(
	.d(state_new[7]),
	.q(state_current[7]),
	.wen(wen),
	.clk(clk),
	.rst(rst)
);


dff bit8(
	.d(state_new[8]),
	.q(state_current[8]),
	.wen(wen),
	.clk(clk),
	.rst(rst)
);


dff bit9(
	.d(state_new[9]),
	.q(state_current[9]),
	.wen(wen),
	.clk(clk),
	.rst(rst)
);


dff bit10(
	.d(state_new[10]),
	.q(state_current[10]),
	.wen(wen),
	.clk(clk),
	.rst(rst)
);

dff bit11(
	.d(state_new[11]),
	.q(state_current[11]),
	.wen(wen),
	.clk(clk),
	.rst(rst)
);

dff bit12(
	.d(state_new[12]),
	.q(state_current[12]),
	.wen(wen),
	.clk(clk),
	.rst(rst)
);

dff bit13(
	.d(state_new[13]),
	.q(state_current[13]),
	.wen(wen),
	.clk(clk),
	.rst(rst)
);

dff bit14(
	.d(state_new[14]),
	.q(state_current[14]),
	.wen(wen),
	.clk(clk),
	.rst(rst)
);
dff bit15(
	.d(state_new[15]),
	.q(state_current[15]),
	.wen(wen),
	.clk(clk),
	.rst(rst)
);

endmodule


