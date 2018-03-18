module cpu(
	input clk,
	input rst_n,
	output hlt,
	output [15:0] pc
);


wire [2:0]C; 
wire [2:0]F;
wire [15:0]PC_in;
wire [15:0]PC_out;
wire [15:0]instruction;
wire [3:0]write_reg;
wire [15:0]Read_data_1;
wire [15:0]Read_data_2;
wire [15:0]Write_data;
wire RegWrite;
wire [15:0]pc_current;
assign pc = pc_current;
wire [15:0]signextend;
wire [15:0]muxtoalu;
wire [15:0]ALU_out;
wire [15:0]Data_memory_out;
wire MemWrite;
wire RegDst;
wire ALUsrc;
wire MemtoReg;
wire hlt_internal;

assign hlt = hlt_internal;

PC_Register pc_reg(
	.PC_new(PC_out),
	.clk(clk),
	.rst(rst_n),
	.PC_current(pc_current)
);

memory instrucion_mem(
	.data_out(instruction), 
	.data_in({15{1'b0}}), 
	.addr(pc_current), 
	.enable(1'b1), 
	.wr(1'b0), 
	.clk(clk), 
	.rst(rst_n)
);


PC_control pc_control(
	.C(C),
	.I(instruction[8:0]), 
	.F(F), 
	.hlt(hlt_internal),
	.PC_in(PC_in),
	.PC_out(pc_out)
);

assign write_reg = (RegDst)? instruction[3:0]: instruction[7:4];

RegisterFile RegisterFile(
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

assign signextend = {{12{instruction[8]}}, instruction[3:0]};
assign muxtoalu = (ALUsrc) ? signextend: Read_data_2;

ALU alu(
	.ALU_in1(Read_data_1), 
	.ALU_in2(muxtoalu), 
	.op(instruction[14:12]), 
	.ALU_out(ALU_out), 
	.flag(F)
);



memory1c Data_memory(
	.data_out(Data_memory_out), 
	.data_in(Read_data_2), 
	.addr(ALU_out), 
	.enable(1'b1), 
	.wr(MemWrite), 
	.clk(clk), 
	.rst(rst_n)
);


assign Write_data = (MemtoReg)? Data_memory_out:ALU_out;

endmodule




