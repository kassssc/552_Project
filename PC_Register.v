module PC_Register(
	input [15:0]PC_new,
	input clk,
	input rst,
	output [15:0] PC_current
);

	wire [15:0] current;
	assign pc_current = current;

dff PC_bit0(
	.d(PC_new[0]), 
	.q(current[0]), 
	.wen(1'b1), 
	.clk(clk), 
	.rst(rst)
);

dff PC_bit1(
	.d(PC_new[1]), 
	.q(current[1]), 
	.wen(1'b1), 
	.clk(clk), 
	.rst(rst)
);

dff PC_bit2(
	.d(PC_new[2]), 
	.q(current[2]), 
	.wen(1'b1), 
	.clk(clk), 
	.rst(rst)
);

dff PC_bit3(
	.d(PC_new[3]), 
	.q(current[3]), 
	.wen(1'b1), 
	.clk(clk), 
	.rst(rst)
);

dff PC_bit4(
	.d(PC_new[4]), 
	.q(current[4]), 
	.wen(1'b1), 
	.clk(clk), 
	.rst(rst)
);

dff PC_bit5(
	.d(PC_new[5]), 
	.q(current[5]), 
	.wen(1'b1), 
	.clk(clk), 
	.rst(rst)
);

dff PC_bit6(
	.d(PC_new[6]), 
	.q(current[6]), 
	.wen(1'b1), 
	.clk(clk), 
	.rst(rst)
);


dff PC_bit7(
	.d(PC_new[7]), 
	.q(current[7]), 
	.wen(1'b1), 
	.clk(clk), 
	.rst(rst)
);


dff PC_bit8(
	.d(PC_new[8]), 
	.q(current[8]), 
	.wen(1'b1), 
	.clk(clk), 
	.rst(rst)
);


dff PC_bit9(
	.d(PC_new[9]), 
	.q(current[9]), 
	.wen(1'b1), 
	.clk(clk), 
	.rst(rst)
);


dff PC_bit10(
	.d(PC_new[10]), 
	.q(current[10]), 
	.wen(1'b1), 
	.clk(clk), 
	.rst(rst)
);

dff PC_bit11(
	.d(PC_new[11]), 
	.q(current[11]), 
	.wen(1'b1), 
	.clk(clk), 
	.rst(rst)
);

dff PC_bit12(
	.d(PC_new[12]), 
	.q(current[12]), 
	.wen(1'b1), 
	.clk(clk), 
	.rst(rst)
);

dff PC_bit13(
	.d(PC_new[13]), 
	.q(current[13]), 
	.wen(1'b1), 
	.clk(clk), 
	.rst(rst)
);

dff PC_bit14(
	.d(PC_new[14]), 
	.q(current[14]), 
	.wen(1'b1), 
	.clk(clk), 
	.rst(rst)
);
dff PC_bit15(
	.d(PC_new[15]), 
	.q(current[15]), 
	.wen(1'b1), 
	.clk(clk), 
	.rst(rst)
);

endmodule

