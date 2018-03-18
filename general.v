module MUX_81_16b (sel, i0, i1, i2, i3, i4, i5, i6, i7, out);
	input	[2:0]	sel;
	input	[15:0]	i0, i1, i2, i3, i4, i5, i6, i7;
	output	[15:0]	out;
	reg		[15:0]	out;

	always @(*) begin
		case (sel)
			3'b000: out = i0;
			3'b001: out = i1;
			3'b010: out = i2;
			3'b011: out = i3;
			3'b100: out = i4;
			3'b101: out = i5;
			3'b110: out = i6;
			3'b111: out = i7;
			default: out = i0;
		endcase
	end
endmodule // mux_81_16b

module MUX_21_1b (sel, i0, i1, out);
	input	sel, i0, i1;
	output	out;
	reg		out;

	always @(*) begin
		case (sel)
			1'b0: out = i0;
			1'b1: out = i1;
			default: out = i0;
		endcase
	end
endmodule

module MUX_21_16b (sel, i0, i1, out);
	input	sel;
	input	[15:0]	i0, i1;
	output	[15:0]	out;
	reg		[15:0]	out;

	always @(*) begin
		case (sel)
			1'b0: out = i0;
			1'b1: out = i1;
			default: out = i0;
		endcase
	end
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