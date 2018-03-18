module PC_Register(
	input [15:0]PC_new,
	input clk,
	input rst,
	output [15:0]PC_current
);

dff PC_bit0(
	.d(PC_new[0]), 
	.q(PC_current[0]), 
	.wen(1'b1), 
	.clk(clk), 
	.rst(rst)
);

dff PC_bit1(
	.d(PC_new[1]), 
	.q(PC_current[1]), 
	.wen(1'b1), 
	.clk(clk), 
	.rst(rst)
);

dff PC_bit2(
	.d(PC_new[2]), 
	.q(PC_current[2]), 
	.wen(1'b1), 
	.clk(clk), 
	.rst(rst)
);

dff PC_bit3(
	.d(PC_new[3]), 
	.q(PC_current[3]), 
	.wen(1'b1), 
	.clk(clk), 
	.rst(rst)
);

dff PC_bit4(
	.d(PC_new[4]), 
	.q(PC_current[4]), 
	.wen(1'b1), 
	.clk(clk), 
	.rst(rst)
);

dff PC_bit5(
	.d(PC_new[5]), 
	.q(PC_current[5]), 
	.wen(1'b1), 
	.clk(clk), 
	.rst(rst)
);

dff PC_bit6(
	.d(PC_new[6]), 
	.q(PC_current[6]), 
	.wen(1'b1), 
	.clk(clk), 
	.rst(rst)
);


dff PC_bit7(
	.d(PC_new[7]), 
	.q(PC_current[7]), 
	.wen(1'b1), 
	.clk(clk), 
	.rst(rst)
);


dff PC_bit8(
	.d(PC_new[8]), 
	.q(PC_current[8]), 
	.wen(1'b1), 
	.clk(clk), 
	.rst(rst)
);


dff PC_bit9(
	.d(PC_new[9]), 
	.q(PC_current[9]), 
	.wen(1'b1), 
	.clk(clk), 
	.rst(rst)
);


dff PC_bit10(
	.d(PC_new[10]), 
	.q(PC_current[10]), 
	.wen(1'b1), 
	.clk(clk), 
	.rst(rst)
);

dff PC_bit11(
	.d(PC_new[11]), 
	.q(PC_current[11]), 
	.wen(1'b1), 
	.clk(clk), 
	.rst(rst)
);

dff PC_bit12(
	.d(PC_new[12]), 
	.q(PC_current[12]), 
	.wen(1'b1), 
	.clk(clk), 
	.rst(rst)
);

dff PC_bit13(
	.d(PC_new[13]), 
	.q(PC_current[13]), 
	.wen(1'b1), 
	.clk(clk), 
	.rst(rst)
);

dff PC_bit14(
	.d(PC_new[14]), 
	.q(PC_current[14]), 
	.wen(1'b1), 
	.clk(clk), 
	.rst(rst)
);
dff PC_bit15(
	.d(PC_new[15]), 
	.q(PC_current[15]), 
	.wen(1'b1), 
	.clk(clk), 
	.rst(rst)
);

endmodule

