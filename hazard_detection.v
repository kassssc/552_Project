module hazard_detection(
	input [15:0] if_id_instr,
	input [15:0] id_ex_instr,
	input id_ex_memread,
	output stall,
	output [1:0]cycle_number
);

wire hlt_h;
wire hlt_h_d;
wire ishlt;
wire hlt_count;
wire [1:0]S;
wire data_hazard;
wire control_hazard;
assign hlt_h = (if_id_instr[15:12] == 4'b1111)? 1'b1:1'b0;

// detect rising edge
assign ishlt = (hlt_h & ~hlt_h_d);

dff hlt(
	.d(1'b1),
	.q(hlt_count),
	.wen(temp),
	.clk(clk),
	.rst(rst)
);

full_adder_2b (hlt_count, 2'b00, 1'b0, S, 1'b0);

wire if_id_rs = if_id_instr[7:4];
wire if_id_rt = if_id_instr[3:0];
wire id_ex_rt = id_ex_instr[7:4]; 
wire opcode = if_id_instr[15:12];

assign data_hazard = (id_ex_memread & (if_id_rs == id_ex_rt)) ? 1'b1:
					 (id_ex_memread & (if_id_rt == if_id_rt)) ? 1'b1:1'b0;

assign control_hazard = (if_id_instr[15:12] == 4'b1100)? 1'b1:
						(if_id_instr[15:12] == 4'b1101)? 1'b1:
						(if_id_instr[15:12] == 4'b1111)? 1'b1:
						1'b0;

assign cycle_number =   (if_id_instr[15:12] == 4'b1100)? 2'b10:
						(if_id_instr[15:12] == 4'b1101)? 2'b10:2'b00;						

assign stall = (S == 2'b11?)? 1'b1:
				(control_hazard | data_hazard)? 1'b1:1'b0;

endmodule			