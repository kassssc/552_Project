module MUX_21_1b (sel, i0, i1, out);

input		i0, i1;
input 		sel;
output		out;
reg			inter;

always @(*) begin
	case (sel)
		1'b0: inter = i0;
		1'b1: inter = i1;
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

module MUX_81_16b (sel, i0, i1, i2, i3, i4, i5, i6, i7, out);

input	[2:0]	sel;
input	[15:0]	i0, i1, i2, i3, i4, i5, i6, i7;
output	[15:0]	out;
reg		[15:0]	inter;

always @(*) begin
	case (sel)
		3'b000: inter = i0;
		3'b001: inter = i1;
		3'b010: inter = i2;
		3'b011: inter = i3;
		3'b100: inter = i4;
		3'b101: inter = i5;
		3'b110: inter = i6;
		3'b111: inter = i7;
		default: inter = i0;
	endcase
end

assign out = inter;

endmodule // mux_81_16b

module DECODER_3_8(
	input[2:0] id_in,
	output[7:0] one_hot_out
);

	reg [7:0]one_hot_reg;
	assign one_hot_out = one_hot_reg;

	always@(*) begin
		case (id_in)
			3'b000: one_hot_reg = 8'h01;
			3'b001: one_hot_reg = 8'h02;
			3'b010: one_hot_reg = 8'h04;
			3'b011: one_hot_reg = 8'h08;
			3'b100: one_hot_reg = 8'h10;
			3'b101: one_hot_reg = 8'h20;
			3'b110: one_hot_reg = 8'h40;
			3'b111: one_hot_reg = 8'h80;
			default : one_hot_reg = 8'h00;
		endcase
	end
endmodule

module DECODER_7_128(
	input[6:0] id_in,
	output[127:0] one_hot_out
);

	reg [127:0]one_hot_reg;
	assign one_hot_out = one_hot_reg;

	always@(*) begin
		case (id_in)
			7'h 0: one_hot_reg = 128'h                               1;
			7'h 1: one_hot_reg = 128'h                               2;
			7'h 2: one_hot_reg = 128'h                               4;
			7'h 3: one_hot_reg = 128'h                               8;
			7'h 4: one_hot_reg = 128'h                              10;
			7'h 5: one_hot_reg = 128'h                              20;
			7'h 6: one_hot_reg = 128'h                              40;
			7'h 7: one_hot_reg = 128'h                              80;
			7'h 8: one_hot_reg = 128'h                             100;
			7'h 9: one_hot_reg = 128'h                             200;
			7'h a: one_hot_reg = 128'h                             400;
			7'h b: one_hot_reg = 128'h                             800;
			7'h c: one_hot_reg = 128'h                            1000;
			7'h d: one_hot_reg = 128'h                            2000;
			7'h e: one_hot_reg = 128'h                            4000;
			7'h f: one_hot_reg = 128'h                            8000;
			7'h10: one_hot_reg = 128'h                           10000;
			7'h11: one_hot_reg = 128'h                           20000;
			7'h12: one_hot_reg = 128'h                           40000;
			7'h13: one_hot_reg = 128'h                           80000;
			7'h14: one_hot_reg = 128'h                          100000;
			7'h15: one_hot_reg = 128'h                          200000;
			7'h16: one_hot_reg = 128'h                          400000;
			7'h17: one_hot_reg = 128'h                          800000;
			7'h18: one_hot_reg = 128'h                         1000000;
			7'h19: one_hot_reg = 128'h                         2000000;
			7'h1a: one_hot_reg = 128'h                         4000000;
			7'h1b: one_hot_reg = 128'h                         8000000;
			7'h1c: one_hot_reg = 128'h                        10000000;
			7'h1d: one_hot_reg = 128'h                        20000000;
			7'h1e: one_hot_reg = 128'h                        40000000;
			7'h1f: one_hot_reg = 128'h                        80000000;
			7'h20: one_hot_reg = 128'h                       100000000;
			7'h21: one_hot_reg = 128'h                       200000000;
			7'h22: one_hot_reg = 128'h                       400000000;
			7'h23: one_hot_reg = 128'h                       800000000;
			7'h24: one_hot_reg = 128'h                      1000000000;
			7'h25: one_hot_reg = 128'h                      2000000000;
			7'h26: one_hot_reg = 128'h                      4000000000;
			7'h27: one_hot_reg = 128'h                      8000000000;
			7'h28: one_hot_reg = 128'h                     10000000000;
			7'h29: one_hot_reg = 128'h                     20000000000;
			7'h2a: one_hot_reg = 128'h                     40000000000;
			7'h2b: one_hot_reg = 128'h                     80000000000;
			7'h2c: one_hot_reg = 128'h                    100000000000;
			7'h2d: one_hot_reg = 128'h                    200000000000;
			7'h2e: one_hot_reg = 128'h                    400000000000;
			7'h2f: one_hot_reg = 128'h                    800000000000;
			7'h30: one_hot_reg = 128'h                   1000000000000;
			7'h31: one_hot_reg = 128'h                   2000000000000;
			7'h32: one_hot_reg = 128'h                   4000000000000;
			7'h33: one_hot_reg = 128'h                   8000000000000;
			7'h34: one_hot_reg = 128'h                  10000000000000;
			7'h35: one_hot_reg = 128'h                  20000000000000;
			7'h36: one_hot_reg = 128'h                  40000000000000;
			7'h37: one_hot_reg = 128'h                  80000000000000;
			7'h38: one_hot_reg = 128'h                 100000000000000;
			7'h39: one_hot_reg = 128'h                 200000000000000;
			7'h3a: one_hot_reg = 128'h                 400000000000000;
			7'h3b: one_hot_reg = 128'h                 800000000000000;
			7'h3c: one_hot_reg = 128'h                1000000000000000;
			7'h3d: one_hot_reg = 128'h                2000000000000000;
			7'h3e: one_hot_reg = 128'h                4000000000000000;
			7'h3f: one_hot_reg = 128'h                8000000000000000;
			7'h40: one_hot_reg = 128'h               10000000000000000;
			7'h41: one_hot_reg = 128'h               20000000000000000;
			7'h42: one_hot_reg = 128'h               40000000000000000;
			7'h43: one_hot_reg = 128'h               80000000000000000;
			7'h44: one_hot_reg = 128'h              100000000000000000;
			7'h45: one_hot_reg = 128'h              200000000000000000;
			7'h46: one_hot_reg = 128'h              400000000000000000;
			7'h47: one_hot_reg = 128'h              800000000000000000;
			7'h48: one_hot_reg = 128'h             1000000000000000000;
			7'h49: one_hot_reg = 128'h             2000000000000000000;
			7'h4a: one_hot_reg = 128'h             4000000000000000000;
			7'h4b: one_hot_reg = 128'h             8000000000000000000;
			7'h4c: one_hot_reg = 128'h            10000000000000000000;
			7'h4d: one_hot_reg = 128'h            20000000000000000000;
			7'h4e: one_hot_reg = 128'h            40000000000000000000;
			7'h4f: one_hot_reg = 128'h            80000000000000000000;
			7'h50: one_hot_reg = 128'h           100000000000000000000;
			7'h51: one_hot_reg = 128'h           200000000000000000000;
			7'h52: one_hot_reg = 128'h           400000000000000000000;
			7'h53: one_hot_reg = 128'h           800000000000000000000;
			7'h54: one_hot_reg = 128'h          1000000000000000000000;
			7'h55: one_hot_reg = 128'h          2000000000000000000000;
			7'h56: one_hot_reg = 128'h          4000000000000000000000;
			7'h57: one_hot_reg = 128'h          8000000000000000000000;
			7'h58: one_hot_reg = 128'h         10000000000000000000000;
			7'h59: one_hot_reg = 128'h         20000000000000000000000;
			7'h5a: one_hot_reg = 128'h         40000000000000000000000;
			7'h5b: one_hot_reg = 128'h         80000000000000000000000;
			7'h5c: one_hot_reg = 128'h        100000000000000000000000;
			7'h5d: one_hot_reg = 128'h        200000000000000000000000;
			7'h5e: one_hot_reg = 128'h        400000000000000000000000;
			7'h5f: one_hot_reg = 128'h        800000000000000000000000;
			7'h60: one_hot_reg = 128'h       1000000000000000000000000;
			7'h61: one_hot_reg = 128'h       2000000000000000000000000;
			7'h62: one_hot_reg = 128'h       4000000000000000000000000;
			7'h63: one_hot_reg = 128'h       8000000000000000000000000;
			7'h64: one_hot_reg = 128'h      10000000000000000000000000;
			7'h65: one_hot_reg = 128'h      20000000000000000000000000;
			7'h66: one_hot_reg = 128'h      40000000000000000000000000;
			7'h67: one_hot_reg = 128'h      80000000000000000000000000;
			7'h68: one_hot_reg = 128'h     100000000000000000000000000;
			7'h69: one_hot_reg = 128'h     200000000000000000000000000;
			7'h6a: one_hot_reg = 128'h     400000000000000000000000000;
			7'h6b: one_hot_reg = 128'h     800000000000000000000000000;
			7'h6c: one_hot_reg = 128'h    1000000000000000000000000000;
			7'h6d: one_hot_reg = 128'h    2000000000000000000000000000;
			7'h6e: one_hot_reg = 128'h    4000000000000000000000000000;
			7'h6f: one_hot_reg = 128'h    8000000000000000000000000000;
			7'h70: one_hot_reg = 128'h   10000000000000000000000000000;
			7'h71: one_hot_reg = 128'h   20000000000000000000000000000;
			7'h72: one_hot_reg = 128'h   40000000000000000000000000000;
			7'h73: one_hot_reg = 128'h   80000000000000000000000000000;
			7'h74: one_hot_reg = 128'h  100000000000000000000000000000;
			7'h75: one_hot_reg = 128'h  200000000000000000000000000000;
			7'h76: one_hot_reg = 128'h  400000000000000000000000000000;
			7'h77: one_hot_reg = 128'h  800000000000000000000000000000;
			7'h78: one_hot_reg = 128'h 1000000000000000000000000000000;
			7'h79: one_hot_reg = 128'h 2000000000000000000000000000000;
			7'h7a: one_hot_reg = 128'h 4000000000000000000000000000000;
			7'h7b: one_hot_reg = 128'h 8000000000000000000000000000000;
			7'h7c: one_hot_reg = 128'h10000000000000000000000000000000;
			7'h7d: one_hot_reg = 128'h20000000000000000000000000000000;
			7'h7e: one_hot_reg = 128'h40000000000000000000000000000000;
			7'h7f: one_hot_reg = 128'h80000000000000000000000000000000;
			default : one_hot_reg = 128'h0;
		endcase
	end
endmodule

module WriteDecoder_4_16(
	input [3:0] RegId,
	input WriteReg,
	output [15:0] Wordline
);

assign Wordline =   (RegId == 4'b0000) ? 16'h0001 & {16{WriteReg}}:
					(RegId == 4'b0001) ? 16'h0002 & {16{WriteReg}}:
					(RegId == 4'b0010) ? 16'h0004 & {16{WriteReg}}:
					(RegId == 4'b0011) ? 16'h0008 & {16{WriteReg}}:
					(RegId == 4'b0100) ? 16'h0010 & {16{WriteReg}}:
					(RegId == 4'b0101) ? 16'h0020 & {16{WriteReg}}:
					(RegId == 4'b0110) ? 16'h0040 & {16{WriteReg}}:
					(RegId == 4'b0111) ? 16'h0080 & {16{WriteReg}}:
					(RegId == 4'b1000) ? 16'h0100 & {16{WriteReg}}:
					(RegId == 4'b1001) ? 16'h0200 & {16{WriteReg}}:
					(RegId == 4'b1010) ? 16'h0400 & {16{WriteReg}}:
					(RegId == 4'b1011) ? 16'h0800 & {16{WriteReg}}:
					(RegId == 4'b1100) ? 16'h1000 & {16{WriteReg}}:
					(RegId == 4'b1101) ? 16'h2000 & {16{WriteReg}}:
					(RegId == 4'b1110) ? 16'h4000 & {16{WriteReg}}: 16'h8000 & {16{WriteReg}};

endmodule

module ReadDecoder_4_16(
	input [3:0] RegId,
	output [15:0] Wordline
);
	assign Wordline =   (RegId == 4'b0000) ? 16'h0001:
						(RegId == 4'b0001) ? 16'h0002:
						(RegId == 4'b0010) ? 16'h0004:
						(RegId == 4'b0011) ? 16'h0008:
						(RegId == 4'b0100) ? 16'h0010:
						(RegId == 4'b0101) ? 16'h0020:
						(RegId == 4'b0110) ? 16'h0040:
						(RegId == 4'b0111) ? 16'h0080:
						(RegId == 4'b1000) ? 16'h0100:
						(RegId == 4'b1001) ? 16'h0200:
						(RegId == 4'b1010) ? 16'h0400:
						(RegId == 4'b1011) ? 16'h0800:
						(RegId == 4'b1100) ? 16'h1000:
						(RegId == 4'b1101) ? 16'h2000:
						(RegId == 4'b1110) ? 16'h4000:16'h8000;
endmodule
