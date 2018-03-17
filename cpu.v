module cpu{
	input clk,
	input rst_n,
	output hlt,
	output [15:0] pc
};

reg [15:0] pc_current;
wire [2:0]C,
wire [8:0]I, 
wire [2:0]F,
wire [15:0]PC_in,
wire [15:0]PC_out
wire [15:0]instruction;
wire [3:0]write_reg;
wire [15:0]Read_data_1;
wire [15:0]Read_data_2;
wire [15:0]Write_data;
wire RegWrite;
assign pc = pc_current;

memory instrucion_mem{
	.data_out(instruction), 
	.data_in({15{1'b0}}), 
	.addr(pc_current), 
	.enable(1'b1), 
	.wr(1'b0), 
	.clk(clk), 
	.rst(rst_n)
}


PC_control pc_control(
	.C(C),
	.I(I), 
	.F(F), 
	.PC_in(PC_in),
	.PC_out(pc_out)
);

assign write_reg = (RegDst?) instruction[3:0]: instruction[7:4];

RegisterFile(
	.clk(clk), 
	.rst(rst_n), 
	.SrcReg1(instruction[11:8]), 
	.SrcReg2(instruction[7:4]), 
	.DstReg(instruction[3:0]), 
	.WriteReg(RegWrite), 
	.DstData(Write_data), 
	.SrcData1(Read_data_1), 
	.SrcData2(Read_data_2)
);



