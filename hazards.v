module hazard_detection(
	input [15:0] if_id_instr,
	input [15:0] id_ex_instr,
	input id_ex_memread,
	input clk,
	input rst,
	output stall,
	output flush,
	output hlt_out
);

wire control;
wire hlt;
wire data;
 
//************************************
//*	HLT
//************************************
assign hlt_out = hlt;

wire hlt_h;
wire hlt_h_d;
wire ishlt;
wire hlt_count;
wire cout;
wire [1:0]S;

assign hlt_h = (if_id_instr[15:12] == 4'b1111)? 1'b1:1'b0;

dff hlt_ff(
	.d(hlt_h),
	.q(hlt_h_d),
	.wen(1'b1),
	.clk(clk),
	.rst(rst)
);

// detect rising edge
assign ishlt = (hlt_h & ~hlt_h_d);

dff hltff(
	.d(1'b1),
	.q(hlt_count),
	.wen(ishlt),
	.clk(clk),
	.rst(rst)
);

full_adder_2b adder({1'b0,hlt_count}, 2'b00, 1'b0, S, cout);

assign hlt = (S == 2'b11)? 1'b1:1'b0;

//************************************
//*	Data
//************************************
wire if_id_rs;
wire if_id_rt;
wire id_ex_rt;

assign if_id_rs = if_id_instr[7:4];
assign if_id_rt = if_id_instr[3:0];
assign id_ex_rt = if_id_instr[3:0];

assign data_hazard = (id_ex_memread & (if_id_rs == id_ex_rt)) ? 1'b1:
					 (id_ex_memread & (if_id_rt == id_ex_rt)) ? 1'b1:1'b0;

wire data_hazard_out1;
wire data_hazard_out2;

dff dataff1(
	.d(data_hazard),
	.q(data_hazard_out1),
	.wen(1'b1),
	.clk(clk),
	.rst(rst)
);
dff dataff2(
	.d(data_hazard_out1),
	.q(data_hazard_out2),
	.wen(1'b1),
	.clk(clk),
	.rst(rst)
);
assign flush = data_hazard | data_hazard_out1 | data_hazard_out2;
assign stall = hlt | (data_hazard | data_hazard_out1 | data_hazard_out2);

endmodule