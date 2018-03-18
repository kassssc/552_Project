module full_adder_1bit(A, B, Cin, S, Cout);

	input A, B, Cin;
	output S, Cout;

	assign S = A ^ B ^ Cin;
	assign Cout = (A & B) | (B & Cin) | (A & Cin);

endmodule

module full_adder_4bit(A, B, Cin, Sum, Cout);

	input Cin;
	input[3:0] A, B;
	output[3:0] Sum;
	output Cout;

	wire[3:0] inter;
	assign Cout = inter[3];

	full_adder_1bit FA0(.A(A[0]),
						.B(B[0]), 
						.Cin(Cin), 
						.S(Sum[0]), 
						.Cout(inter[0])
						);
						
	full_adder_1bit FA1(.A(A[1]),
						.B(B[1]), 
						.Cin(inter[0]), 
						.S(Sum[1]), 
						.Cout(inter[1])
						);					
						
	full_adder_1bit FA2(.A(A[2]),
						.B(B[2]), 
						.Cin(inter[1]), 
						.S(Sum[2]), 
						.Cout(inter[2])
						);					
						
	full_adder_1bit FA3(.A(A[3]),
						.B(B[3]), 
						.Cin(inter[2]), 
						.S(Sum[3]), 
						.Cout(inter[3])
						);					
					
endmodule

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
