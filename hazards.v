module hazard_detection(
	input [15:0] if_id_instr,
	input [15:0] id_ex_instr,
	input id_ex_MemToReg,
	input clk,
	input rst,
	input flush,
	output stall,
	output hlt_out
);

wire control;
wire hlt;
wire data;

//************************************
//*	HLT
//************************************
wire hlt_h1, hlt_h2, hlt_h3;
assign hlt_out = hlt;

reg hlt_h;
wire hlt_h_d;
wire ishlt;
wire cout;

always@(if_id_instr) begin
    hlt_h = 1'b0;
	case (if_id_instr[15:12])
		4'b1111: hlt_h = 1'b1;
		default: hlt_h = 1'b0;
	endcase
end


dff hlt_ff0(
	.d(hlt_h),
	.q(hlt_h1),
	.wen(1'b1),
	.clk(clk),
	.rst(rst | flush)
);
dff hlt_ff1(
	.d(hlt_h1),
	.q(hlt_h2),
	.wen(1'b1),
	.clk(clk),
	.rst(rst | flush)
);
dff hlt_ff2(
	.d(hlt_h2),
	.q(hlt_h3),
	.wen(1'b1),
	.clk(clk),
	.rst(rst | flush)
);

// detect rising edge
assign ishlt = hlt_h3;

dff hltff(
	.d(1'b1),
	.q(hlt),
	.wen(ishlt),
	.clk(clk),
	.rst(rst)
);



//************************************
//*	Data
//************************************

wire if_id_rs;
wire if_id_rt;
reg [3:0]id_ex_write_reg;


assign if_id_rs_out = if_id_rs;
assign if_id_rt_out = if_id_rt;

wire data_hazard_internal;

//assign if_id_rt = if_id_instr[3:0];
//assign id_ex_write_reg = id_ex_instr[3:0];

always@(id_ex_instr) begin
	case(id_ex_instr)
		4'b0000: id_ex_write_reg = 4'b0000;
		4'b0001: id_ex_write_reg = 4'b0001;
		4'b0010: id_ex_write_reg = 4'b0010;
		4'b0011: id_ex_write_reg = 4'b0011;
		4'b0100: id_ex_write_reg = 4'b0100;
		4'b0101: id_ex_write_reg = 4'b0101;
		4'b0110: id_ex_write_reg = 4'b0110;
		4'b0111: id_ex_write_reg = 4'b0111;
		4'b1000: id_ex_write_reg = 4'b1000;
		4'b1001: id_ex_write_reg = 4'b1001;
		4'b1010: id_ex_write_reg = 4'b1010;
		4'b1011: id_ex_write_reg = 4'b1011;
		4'b1100: id_ex_write_reg = 4'b1100;
		4'b1101: id_ex_write_reg = 4'b1101;
		4'b1110: id_ex_write_reg = 4'b1110;
		4'b1111: id_ex_write_reg = 4'b1111;
		default: id_ex_write_reg = 4'b1111;
	endcase
end
		
//assign id_ex_write_reg = id_ex_instr[11:8];

reg ID_lhb, ID_llb, RegToMem, MemToReg;
wire reset;

always@(if_id_instr) begin
	ID_lhb = 1'b0;
	ID_llb = 1'b0;
	MemToReg = 1'b0;
	RegToMem = 1'b0;

	case(if_id_instr)
		4'b1010: ID_lhb = 1'b1;
		4'b1011: ID_llb = 1'b1;
		4'b1000: MemToReg = 1'b1;
		4'b1001: RegToMem = 1'b1;
		default: begin 
				ID_lhb = 1'b0;
				ID_llb = 1'b0;
				MemToReg = 1'b0;
				RegToMem = 1'b0;
		end
	endcase
end
		

//assign ID_lhb = (if_id_instr[15:12] == 4'b1010);
//assign ID_llb = (if_id_instr[15:12] == 4'b1011);
//assign MemToReg = (if_id_instr[15:12] == 4'b1000); //LW
//assign RegToMem = (if_id_instr[15:12] == 4'b1001); //SW

assign if_id_rs = (RegToMem | ID_lhb | ID_llb | MemToReg)?
							((RegToMem | ID_lhb | ID_llb)? if_id_instr[11:8]:if_id_instr[7:4]):
							4'b0000;
assign if_id_rt = (RegToMem | ID_lhb | ID_llb | MemToReg)?
							((RegToMem | MemToReg)? if_id_instr[7:4] : if_id_instr[3:0]):
							4'b0000;


assign data_hazard_internal =   (~reset) ?  1'b0:
								(id_ex_MemToReg & (if_id_rs == id_ex_write_reg)) ? 1'b1:
								(id_ex_MemToReg & (if_id_rt == id_ex_write_reg)) ? 1'b1:1'b0;


dff reset_ff(
	.d(1'b1),
	.q(reset),
	.wen(1'b1),
	.clk(clk),
	.rst(data_hazard_internal)
);
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