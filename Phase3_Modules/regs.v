module reg_4b(
	input [3:0]reg_new,
	input wen,
	input clk,
	input rst,
	output [3:0]reg_current
);

dff b0(
	.d(reg_new[0]), .q(reg_current[0]), .wen(wen), .clk(clk), .rst(rst)
);
dff b1(
	.d(reg_new[1]), .q(reg_current[1]), .wen(wen), .clk(clk), .rst(rst)
);
dff b2(
	.d(reg_new[2]), .q(reg_current[2]), .wen(wen), .clk(clk), .rst(rst)
);
dff b3(
	.d(reg_new[3]), .q(reg_current[3]), .wen(wen), .clk(clk), .rst(rst)
);

endmodule

module reg_16b(
	input [15:0]reg_new,
	input wen,
	input clk,
	input rst,
	output [15:0]reg_current
);

dff b0(
	.d(reg_new[0]), .q(reg_current[0]), .wen(wen), .clk(clk), .rst(rst)
);
dff b1(
	.d(reg_new[1]), .q(reg_current[1]), .wen(wen), .clk(clk), .rst(rst)
);
dff b2(
	.d(reg_new[2]), .q(reg_current[2]), .wen(wen), .clk(clk), .rst(rst)
);
dff b3(
	.d(reg_new[3]), .q(reg_current[3]), .wen(wen), .clk(clk), .rst(rst)
);
dff b4(
	.d(reg_new[4]), .q(reg_current[4]), .wen(wen), .clk(clk), .rst(rst)
);
dff b5(
	.d(reg_new[5]), .q(reg_current[5]), .wen(wen), .clk(clk), .rst(rst)
);
dff b6(
	.d(reg_new[6]), .q(reg_current[6]), .wen(wen), .clk(clk), .rst(rst)
);
dff b7(
	.d(reg_new[7]), .q(reg_current[7]), .wen(wen), .clk(clk), .rst(rst)
);
dff b8(
	.d(reg_new[8]), .q(reg_current[8]), .wen(wen), .clk(clk), .rst(rst)
);
dff b9(
	.d(reg_new[9]), .q(reg_current[9]), .wen(wen), .clk(clk), .rst(rst)
);
dff b10(
	.d(reg_new[10]), .q(reg_current[10]), .wen(wen), .clk(clk), .rst(rst)
);
dff b11(
	.d(reg_new[11]), .q(reg_current[11]), .wen(wen), .clk(clk), .rst(rst)
);
dff b12(
	.d(reg_new[12]), .q(reg_current[12]), .wen(wen), .clk(clk), .rst(rst)
);
dff b13(
	.d(reg_new[13]), .q(reg_current[13]), .wen(wen), .clk(clk), .rst(rst)
);
dff b14(
	.d(reg_new[14]), .q(reg_current[14]), .wen(wen), .clk(clk), .rst(rst)
);
dff b15(
	.d(reg_new[15]), .q(reg_current[15]), .wen(wen), .clk(clk), .rst(rst)
);

endmodule

module reg_1bit(
	input reg_new,
	input wen,
	input clk,
	input rst,
	output reg_current
);

dff b0(
	.d(reg_new),
	.q(reg_current),
	.wen(wen),
	.clk(clk),
	.rst(rst)
);

endmodule


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