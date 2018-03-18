module SHIFTER_16b(Shift_Out, Shift_In, Shift_Val, Mode);

//This is the number to perform shift operation on
input[15:0] Shift_In; 
//Shift amount (used to shift the ‘Shift_In’)
input[3:0] Shift_Val; 
// To indicate SLL(0) or SRA(1)
input[1:0] Mode;  
//Shifter value
output[15:0] Shift_Out; 

wire [15:0] shift1, shift2, shift4, shift8;
wire [15:0] level1_out, level2_out, level4_out;

//
// First Level Shift (1-bit)
//
MUX_41_1b m1_0 (
	.sel(Mode),	.i0(1'b0), .i1(Shift_In[1]), .i2(Shift_In[1]), .i3(1'b0), .out(shift1[0])
);
MUX_41_1b m1_1 (
	.sel(Mode),	.i0(Shift_In[0]), .i1(Shift_In[2]), .i2(Shift_In[2]), .i3(Shift_In[0]), .out(shift1[1])
);
MUX_41_1b m1_2 (
	.sel(Mode),	.i0(Shift_In[1]), .i1(Shift_In[3]),	.i2(Shift_In[3]), .i3(Shift_In[1]), .out(shift1[2])
);
MUX_41_1b m1_3 (
	.sel(Mode),	.i0(Shift_In[2]), .i1(Shift_In[4]),	.i2(Shift_In[4]), .i3(Shift_In[2]), .out(shift1[3])
);
MUX_41_1b m1_4 (
	.sel(Mode),	.i0(Shift_In[3]), .i1(Shift_In[5]), .i2(Shift_In[5]), .i3(Shift_In[3]), .out(shift1[4])
);
MUX_41_1b m1_5 (
	.sel(Mode),	.i0(Shift_In[4]), .i1(Shift_In[6]),	.i2(Shift_In[6]), .i3(Shift_In[4]), .out(shift1[5])
);
MUX_41_1b m1_6 (
	.sel(Mode),	.i0(Shift_In[5]), .i1(Shift_In[7]),	.i2(Shift_In[7]), .i3(Shift_In[5]), .out(shift1[6])
);
MUX_41_1b m1_7 (
	.sel(Mode),	.i0(Shift_In[6]), .i1(Shift_In[8]),	.i2(Shift_In[8]), .i3(Shift_In[6]), .out(shift1[7])
);
MUX_41_1b m1_8 (
	.sel(Mode),	.i0(Shift_In[7]), .i1(Shift_In[9]),	.i2(Shift_In[9]), .i3(Shift_In[7]), .out(shift1[8])
);
MUX_41_1b m1_9 (
	.sel(Mode),	.i0(Shift_In[8]), .i1(Shift_In[10]), .i2(Shift_In[10]), .i3(Shift_In[8]), .out(shift1[9])
);
MUX_41_1b m1_10 (
	.sel(Mode),	.i0(Shift_In[9]), .i1(Shift_In[11]), .i2(Shift_In[11]), .i3(Shift_In[9]), .out(shift1[10])
);
MUX_41_1b m1_11 (
	.sel(Mode),	.i0(Shift_In[10]), .i1(Shift_In[12]), .i2(Shift_In[12]), .i3(Shift_In[10]), .out(shift1[11])
);
MUX_41_1b m1_12 (
	.sel(Mode),	.i0(Shift_In[11]), .i1(Shift_In[13]), .i2(Shift_In[13]), .i3(Shift_In[11]), .out(shift1[12])
);
MUX_41_1b m1_13 (
	.sel(Mode),	.i0(Shift_In[12]), .i1(Shift_In[14]), .i2(Shift_In[14]), .i3(Shift_In[12]), .out(shift1[13])
);
MUX_41_1b m1_14 (
	.sel(Mode),	.i0(Shift_In[13]), .i1(Shift_In[15]), .i2(Shift_In[15]), .i3(Shift_In[13]), .out(shift1[14])
);
MUX_41_1b m1_15 (
	.sel(Mode),	.i0(Shift_In[14]), .i1(Shift_In[15]), .i2(Shift_In[0]), .i3(Shift_In[14]), .out(shift1[15])
);

//
// Select shift 1-bit or not
//
MUX_21_16b sel_shift1 (
	.sel	(Shift_Val[0]),		// Shift 1-bit?
	.i0		(Shift_In[15:0]),	// No 1-bit shift
	.i1		(shift1[15:0]),		// 1-bit shifted
	.out	(level1_out[15:0])	// Input for next stage shift
);

//
// Second Level Shift (2-bit)
//
MUX_41_1b m2_0 (
	.sel(Mode),	.i0(1'b0), .i1(level1_out[2]), .i2(level1_out[2]), .i3(1'b0), .out(shift2[0])
);
MUX_41_1b m2_1 (
	.sel(Mode),	.i0(1'b0), .i1(level1_out[3]), .i2(level1_out[3]), .i3(1'b0), .out(shift2[1])
);
MUX_41_1b m2_2 (
	.sel(Mode),	.i0(level1_out[0]),	.i1(level1_out[4]), .i2(level1_out[4]), .i3(level1_out[0]), .out(shift2[2])
);
MUX_41_1b m2_3 (
	.sel(Mode),	.i0(level1_out[1]),	.i1(level1_out[5]),	.i2(level1_out[5]), .i3(level1_out[1]), .out(shift2[3])
);
MUX_41_1b m2_4 (
	.sel(Mode),	.i0(level1_out[2]),	.i1(level1_out[6]),	.i2(level1_out[6]), .i3(level1_out[2]), .out(shift2[4])
);
MUX_41_1b m2_5 (
	.sel(Mode),	.i0(level1_out[3]),	.i1(level1_out[7]),	.i2(level1_out[7]), .i3(level1_out[3]), .out(shift2[5])
);
MUX_41_1b m2_6 (
	.sel(Mode),	.i0(level1_out[4]),	.i1(level1_out[8]),	.i2(level1_out[8]), .i3(level1_out[4]), .out(shift2[6])
);
MUX_41_1b m2_7 (
	.sel(Mode),	.i0(level1_out[5]),	.i1(level1_out[9]),	.i2(level1_out[9]), .i3(level1_out[5]), .out(shift2[7])
);
MUX_41_1b m2_8 (
	.sel(Mode),	.i0(level1_out[6]),	.i1(level1_out[10]), .i2(level1_out[10]), .i3(level1_out[6]), .out(shift2[8])
);
MUX_41_1b m2_9 (
	.sel(Mode),	.i0(level1_out[7]),	.i1(level1_out[11]), .i2(level1_out[11]), .i3(level1_out[7]), .out(shift2[9])
);
MUX_41_1b m2_10 (
	.sel(Mode),	.i0(level1_out[8]),	.i1(level1_out[12]), .i2(level1_out[12]), .i3(level1_out[8]), .out(shift2[10])
);
MUX_41_1b m2_11 (
	.sel(Mode),	.i0(level1_out[9]),	.i1(level1_out[13]), .i2(level1_out[13]), .i3(level1_out[9]), .out(shift2[11])
);
MUX_41_1b m2_12 (
	.sel(Mode),	.i0(level1_out[10]), .i1(level1_out[14]), .i2(level1_out[14]), .i3(level1_out[10]), .out(shift2[12])
);
MUX_41_1b m2_13 (
	.sel(Mode),	.i0(level1_out[11]), .i1(level1_out[15]), .i2(level1_out[15]), .i3(level1_out[11]), .out(shift2[13])
);
MUX_41_1b m2_14 (
	.sel(Mode),	.i0(level1_out[12]), .i1(level1_out[15]), .i2(level1_out[0]), .i3(level1_out[12]), .out(shift2[14])
);
MUX_41_1b m2_15 (
	.sel(Mode),	.i0(level1_out[13]), .i1(level1_out[15]), .i2(level1_out[1]), .i3(level1_out[13]), .out(shift2[15])
);

//
// Select shift 2-bit or not
//
MUX_21_16b sel_shift2 (
	.sel	(Shift_Val[1]),		// Shift 2-bit?
	.i0		(level1_out[15:0]),	// No 2-bit shift
	.i1		(shift2[15:0]),		// 2-bit shifted
	.out	(level2_out[15:0])	// Input for next stage shift
);

//
// Third Level Shift (4-bit)
//
MUX_41_1b m3_0 (
	.sel(Mode),	.i0(1'b0), .i1(level2_out[4]), .i2(level2_out[4]), .i3(1'b0), .out(shift4[0])
);
MUX_41_1b m3_1 (
	.sel(Mode),	.i0(1'b0), .i1(level2_out[5]), .i2(level2_out[5]), .i3(1'b0), .out(shift4[1])
);
MUX_41_1b m3_2 (
	.sel(Mode),	.i0(1'b0), .i1(level2_out[6]), .i2(level2_out[6]), .i3(1'b0), .out(shift4[2])
);
MUX_41_1b m3_3 (
	.sel(Mode),	.i0(1'b0), .i1(level2_out[7]), .i2(level2_out[7]), .i3(1'b0), .out(shift4[3])
);
MUX_41_1b m3_4 (
	.sel(Mode),	.i0(level2_out[0]),	.i1(level2_out[8]), .i2(level2_out[8]), .i3(level2_out[0]), .out(shift4[4])
);
MUX_41_1b m3_5 (
	.sel(Mode),	.i0(level2_out[1]),	.i1(level2_out[9]),	.i2(level2_out[9]), .i3(level2_out[1]), .out(shift4[5])
);
MUX_41_1b m3_6 (
	.sel(Mode),	.i0(level2_out[2]),	.i1(level2_out[10]), .i2(level2_out[10]), .i3(level2_out[2]), .out(shift4[6])
);
MUX_41_1b m3_7 (
	.sel(Mode),	.i0(level2_out[3]),	.i1(level2_out[11]), .i2(level2_out[11]), .i3(level2_out[3]), .out(shift4[7])
);
MUX_41_1b m3_8 (
	.sel(Mode),	.i0(level2_out[4]),	.i1(level2_out[12]), .i2(level2_out[12]), .i3(level2_out[4]), .out(shift4[8])
);
MUX_41_1b m3_9 (
	.sel(Mode),	.i0(level2_out[5]),	.i1(level2_out[13]), .i2(level2_out[13]), .i3(level2_out[5]), .out(shift4[9])
);
MUX_41_1b m3_10 (
	.sel(Mode),	.i0(level2_out[6]),	.i1(level2_out[14]), .i2(level2_out[14]), .i3(level2_out[6]), .out(shift4[10])
);
MUX_41_1b m3_11 (
	.sel(Mode),	.i0(level2_out[7]),	.i1(level2_out[15]), .i2(level2_out[15]), .i3(level2_out[7]), .out(shift4[11])
);
MUX_41_1b m3_12 (
	.sel(Mode),	.i0(level2_out[8]),	.i1(level2_out[15]), .i2(level2_out[0]), .i3(level2_out[8]), .out(shift4[12])
);
MUX_41_1b m3_13 (
	.sel(Mode),	.i0(level2_out[9]),	.i1(level2_out[15]), .i2(level2_out[1]), .i3(level2_out[9]), .out(shift4[13])
);
MUX_41_1b m3_14 (
	.sel(Mode),	.i0(level2_out[10]), .i1(level2_out[15]), .i2(level2_out[2]), .i3(level2_out[10]), .out(shift4[14])
);
MUX_41_1b m3_15 (
	.sel(Mode),	.i0(level2_out[11]), .i1(level2_out[15]), .i2(level2_out[3]), .i3(level2_out[11]), .out(shift4[15])
);

//
// Select shift 4-bit or not
//
MUX_21_16b sel_shift4 (
	.sel	(Shift_Val[2]),		// Shift 4-bit?
	.i0		(level2_out[15:0]),	// No 4-bit shift
	.i1		(shift4[15:0]),		// 4-bit shifted
	.out	(level4_out[15:0])	// Input for next stage shift
);

//
// Fourth Level Shift (8-bit)
//
MUX_41_1b m4_0 (
	.sel(Mode),	.i0(1'b0), .i1(level4_out[8]), .i2(level4_out[8]), .i3(1'b0), .out(shift8[0])
);
MUX_41_1b m4_1 (
	.sel(Mode),	.i0(1'b0), .i1(level4_out[9]), .i2(level4_out[9]), .i3(1'b0), .out(shift8[1])
);
MUX_41_1b m4_2 (
	.sel(Mode),	.i0(1'b0), .i1(level4_out[10]),	.i2(level4_out[10]), .i3(1'b0), .out(shift8[2])
);
MUX_41_1b m4_3 (
	.sel(Mode),	.i0(1'b0), .i1(level4_out[11]),	.i2(level4_out[11]), .i3(1'b0), .out(shift8[3])
);
MUX_41_1b m4_4 (
	.sel(Mode),	.i0(1'b0), .i1(level4_out[12]),	.i2(level4_out[12]), .i3(1'b0), .out(shift8[4])
);
MUX_41_1b m4_5 (
	.sel(Mode),	.i0(1'b0), .i1(level4_out[13]),	.i2(level4_out[13]), .i3(1'b0), .out(shift8[5])
);
MUX_41_1b m4_6 (
	.sel(Mode),	.i0(1'b0), .i1(level4_out[14]),	.i2(level4_out[14]), .i3(1'b0), .out(shift8[6])
);
MUX_41_1b m4_7 (
	.sel(Mode),	.i0(1'b0), .i1(level4_out[15]),	.i2(level4_out[15]), .i3(1'b0), .out(shift8[7])
);
MUX_41_1b m4_8 (
	.sel(Mode),	.i0(level4_out[0]),	.i1(level4_out[15]), .i2(level4_out[0]), .i3(level4_out[0]), .out(shift8[8])
);
MUX_41_1b m4_9 (
	.sel(Mode),	.i0(level4_out[1]),	.i1(level4_out[15]), .i2(level4_out[1]), .i3(level4_out[1]), .out(shift8[9])
);
MUX_41_1b m4_10 (
	.sel(Mode),	.i0(level4_out[2]),	.i1(level4_out[15]), .i2(level4_out[2]), .i3(level4_out[2]), .out(shift8[10])
);
MUX_41_1b m4_11 (
	.sel(Mode),	.i0(level4_out[3]),	.i1(level4_out[15]), .i2(level4_out[3]), .i3(level4_out[3]), .out(shift8[11])
);
MUX_41_1b m4_12 (
	.sel(Mode),	.i0(level4_out[4]),	.i1(level4_out[15]), .i2(level4_out[4]), .i3(level4_out[4]), .out(shift8[12])
);
MUX_41_1b m4_13 (
	.sel(Mode),	.i0(level4_out[5]),	.i1(level4_out[15]), .i2(level4_out[5]), .i3(level4_out[5]), .out(shift8[13])
);
MUX_41_1b m4_14 (
	.sel(Mode),	.i0(level4_out[6]),	.i1(level4_out[15]), .i2(level4_out[6]), .i3(level4_out[6]), .out(shift8[14])
);
MUX_41_1b m4_15 (
	.sel(Mode),	.i0(level4_out[7]),	.i1(level4_out[15]), .i2(level4_out[7]), .i3(level4_out[7]), .out(shift8[15])
);

//
// Select shift 8-bit or not
//
MUX_21_16b sel_shift8 (
	.sel	(Shift_Val[3]),		// Shift 8-bit?
	.i0		(level4_out[15:0]),	// No 8-bit shift
	.i1		(shift8[15:0]),		// 8-bit shifted
	.out	(Shift_Out[15:0])	// Final Shifted Value
);

endmodule


module MUX_41_1b (sel, i0, i1, i2, i3, out);

input[1:0]	sel;
input		i0, i1, i2, i3;
output		out;
reg 		inter;

always@(*) begin
	case (sel)
		2'b00: inter = i0;
		2'b01: inter = i1;
		2'b10: inter = i2;
		2'b11: inter = i3;
		default: inter = i0;
	endcase
end

assign out = inter;

endmodule


module MUX_21_16b (sel, i0, i1, out);

input[15:0]		i0, i1;
input 			sel;
output[15:0]	out;
reg[15:0]		inter;

always@(*) begin
	case (sel)
		1'b0: inter = i0;
		1'b1: inter = i1;
		default : inter = i0;
	endcase	
end

assign out = inter;
	
endmodule