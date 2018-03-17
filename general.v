module full_adder_1bit (a, b, cin, cout, s);

	output s, cout;
	input a, b, cin;

	assign s = a ^ b ^ cin;
	assign cout = (a & b) | ((a ^ b) & cin);

endmodule

module MUX_81_16b (sel, i0, i1, i3, i4, i5, i6, i7, out);
	input	[2:0]	sel;
	input	[15:0]	i0, i1, i3, i4, i5, i6, i7;
	output	[15:0]	out;
	reg		[15:0]	out;

	always @(*)
	case (sel)
		3'b000: out = i0;
		3'b001: out = i1;
		3'b010: out = i2;
		3'b011: out = i4;
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

module full_adder_16bit(A, B, Cin, Sum, Cout);

	input Cin;
	input[15:0] A, B;
	output[15:0] Sum;
	output Cout;

	wire[3:0] inter;
	assign Cout = inter[3];

	full_adder_4bit FA0(.A(A[3:0]),
						.B(B[3:0]), 
						.Cin(Cin), 
						.Sum(Sum[3:0]), 
						.Cout(inter[0])
						);

	full_adder_4bit FA1(.A(A[7:4]),
						.B(B[7:4]), 
						.Cin(inter[0]), 
						.Sum(Sum[7:4]), 
						.Cout(inter[1])
						);

	full_adder_4bit FA2(.A(A[11:8]),
						.B(B[11:8]), 
						.Cin(inter[1]), 
						.Sum(Sum[11:8]), 
						.Cout(inter[2])
						);

	full_adder_4bit FA3(.A(A[15:12]),
						.B(B[15:12]), 
						.Cin(inter[2]), 
						.Sum(Sum[15:12]), 
						.Cout(inter[3])
						);
endmodule