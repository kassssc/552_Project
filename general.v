module MUX_81_16b (sel, i0, i1, i2, i3, i4, i5, i6, i7, out);
	input	[2:0]	sel;
	input	[15:0]	i0, i1, i2, i3, i4, i5, i6, i7;
	output	[15:0]	out;
	reg		[15:0]	out;

	always @(*)
	case (sel)
		3'b000: out = i0;
		3'b001: out = i1;
		3'b010: out = i2;
		3'b011: out = i3;
		3'b100: out = i4;
		3'b101: out = i5;
		3'b110: out = i6;
		3'b111: out = i7;
	endcase
endmodule // mux_81_16b

module MUX_21_1b (sel, i0, i1, out);
	input	sel, i0, i1;
	output	out;
	reg		out;

	always @(*)
	case (sel)
		1'b0: out = i0;
		1'b1: out = i1;
	endcase
endmodule

module MUX_21_16b (sel, i0, i1, out);
	input	sel;
	input	[15:0]	i0, i1;
	output	[15:0]	out;
	reg		[15:0]	out;

	always @(*)
	case (sel)
		1'b0: out = i0;
		1'b1: out = i1;
	endcase
endmodule