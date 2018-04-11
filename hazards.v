module hazard_detection(
	input [15:0] if_id_instr,
	input [15:0] id_ex_instr,
	input id_ex_MemToReg,
	input clk,
	input rst,
	output stall,
	output hlt_out
);

wire control;
wire hlt;
wire data;

//************************************
//*	HLT
//************************************
wire hlt_h1, hlt_h2,hlt_h3,hlt_h3_d;
assign hlt_out = hlt_h3;

wire hlt_h;
wire hlt_h_d;
wire ishlt;
wire hlt_count;
wire cout;

assign hlt_h = (if_id_instr[15:12] == 4'b1111)? 1'b1:1'b0;


dff hlt_ff0(
	.d(hlt_h),
	.q(hlt_h1),
	.wen(1'b1),
	.clk(clk),
	.rst(rst)
);
dff hlt_ff1(
	.d(hlt_h1),
	.q(hlt_h2),
	.wen(1'b1),
	.clk(clk),
	.rst(rst)
);
dff hlt_ff2(
	.d(hlt_h2),
	.q(hlt_h3),
	.wen(1'b1),
	.clk(clk),
	.rst(rst)
);

// detect rising edge
assign ishlt = (hlt_h3 & ~hlt_h3_d);

dff hltff(
	.d(1'b1),
	.q(hlt_count),
	.wen(ishlt),
	.clk(clk),
	.rst(rst)
);


assign hlt = hlt_count;

//************************************
//*	Data
//************************************

wire if_id_rs;
wire if_id_rt;
wire id_ex_write_reg;


assign if_id_rs_out = if_id_rs;
assign if_id_rt_out = if_id_rt;

wire data_hazard_internal;
data_hazard_out1_internal

//assign if_id_rt = if_id_instr[3:0];
//assign id_ex_write_reg = id_ex_instr[3:0];


assign id_ex_write_reg = id_ex_instr[11:8];

wire ID_lhb, ID_llb, RegToMem, MemToReg;
wire reset;

assign ID_lhb = (if_id_instr[15:12] == 4'b1010);
assign ID_llb = (if_id_instr[15:12] == 4'b1011);
assign MemToReg = (if_id_instr[15:12] == 4'b100); //LW
assign RegToMem = (if_id_instr[15:12] == 4'b1001); //SW

assign if_id_rs = (RegToMem | ID_lhb | ID_llb)? if_id_instr[11:8] : if_id_instr[7:4];
assign if_id_rt = (RegToMem | MemToReg)? if_id_instr[7:4] : if_id_instr[3:0];

assign reset = data_hazard_internal;

assign data_hazard_internal =   (reset) ?  1'b0:
								(id_ex_MemToReg & (if_id_rs == id_ex_write_reg)) ? 1'b1:
								(id_ex_MemToReg & (if_id_rt == id_ex_write_reg)) ? 1'b1:1'b0;



/*dff dataff1(
	.d(data_hazard_internal),
	.q(data_hazard_out1_internal),
	.wen(1'b1),
	.clk(clk),
	.rst(rst)
);
/*
dff dataff2(
	.d(data_hazard_out1_internal),
	.q(data_hazard_out2_internal),
	.wen(1'b1),
	.clk(clk),
	.rst(rst)
);*/

assign stall = hlt | data_hazard_internal; //| data_hazard_out1_internal | data_hazard_out2_internal);

endmodule