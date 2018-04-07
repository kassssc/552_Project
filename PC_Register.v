module PC_REG (
	input [15:0]pc_new,
	input clk,
	input rst,
	output [15:0] pc_current
);

dff PC_bit0(
	.d(pc_new[0]),
	.q(pc_current[0]),
	.wen(1'b1),
	.clk(clk),
	.rst(rst)
);

dff PC_bit1(
	.d(pc_new[1]),
	.q(pc_current[1]),
	.wen(1'b1),
	.clk(clk),
	.rst(rst)
);

dff PC_bit2(
	.d(pc_new[2]),
	.q(pc_current[2]),
	.wen(1'b1),
	.clk(clk),
	.rst(rst)
);

dff PC_bit3(
	.d(pc_new[3]),
	.q(pc_current[3]),
	.wen(1'b1),
	.clk(clk),
	.rst(rst)
);

dff PC_bit4(
	.d(pc_new[4]),
	.q(pc_current[4]),
	.wen(1'b1),
	.clk(clk),
	.rst(rst)
);

dff PC_bit5(
	.d(pc_new[5]),
	.q(pc_current[5]),
	.wen(1'b1),
	.clk(clk),
	.rst(rst)
);

dff PC_bit6(
	.d(pc_new[6]),
	.q(pc_current[6]),
	.wen(1'b1),
	.clk(clk),
	.rst(rst)
);


dff PC_bit7(
	.d(pc_new[7]),
	.q(pc_current[7]),
	.wen(1'b1),
	.clk(clk),
	.rst(rst)
);


dff PC_bit8(
	.d(pc_new[8]),
	.q(pc_current[8]),
	.wen(1'b1),
	.clk(clk),
	.rst(rst)
);


dff PC_bit9(
	.d(pc_new[9]),
	.q(pc_current[9]),
	.wen(1'b1),
	.clk(clk),
	.rst(rst)
);


dff PC_bit10(
	.d(pc_new[10]),
	.q(pc_current[10]),
	.wen(1'b1),
	.clk(clk),
	.rst(rst)
);

dff PC_bit11(
	.d(pc_new[11]),
	.q(pc_current[11]),
	.wen(1'b1),
	.clk(clk),
	.rst(rst)
);

dff PC_bit12(
	.d(pc_new[12]),
	.q(pc_current[12]),
	.wen(1'b1),
	.clk(clk),
	.rst(rst)
);

dff PC_bit13(
	.d(pc_new[13]),
	.q(pc_current[13]),
	.wen(1'b1),
	.clk(clk),
	.rst(rst)
);

dff PC_bit14(
	.d(pc_new[14]),
	.q(pc_current[14]),
	.wen(1'b1),
	.clk(clk),
	.rst(rst)
);
dff PC_bit15(
	.d(pc_new[15]),
	.q(pc_current[15]),
	.wen(1'b1),
	.clk(clk),
	.rst(rst)
);

endmodule

