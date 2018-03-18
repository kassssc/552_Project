module full_adder_1b (a, b, cin, cout, s);

	output s, cout;
	input a, b, cin;

	assign s = a ^ b ^ cin;
	assign cout = (a & b) | ((a ^ b) & cin);

endmodule

module full_adder_4b (A, B, cin, S, cout);

	input cin;
	input[3:0] A, B;
	output[3:0] S;
	output cout;

	wire[3:0] inter;
	assign cout = inter[3];

	full_adder_1bit FA0(.a(A[0]),
						.b(B[0]), 
						.cin(cin), 
						.s(S[0]), 
						.cout(inter[0])
						);
						
	full_adder_1bit FA1(.a(A[1]),
						.b(B[1]), 
						.cin(inter[0]), 
						.s(S[1]), 
						.cout(inter[1])
						);					
						
	full_adder_1bit FA2(.a(A[2]),
						.b(B[2]), 
						.cin(inter[1]), 
						.s(S[2]), 
						.cout(inter[2])
						);					
						
	full_adder_1bit FA3(.a(A[3]),
						.b(B[3]), 
						.cin(inter[2]), 
						.s(S[3]), 
						.cout(inter[3])
						);					
					
endmodule

module full_adder_16b(A, B, cin, Sum, cout);

	input cin;
	input[15:0] A, B;
	output[15:0] Sum;
	output cout;

	wire[3:0] inter;
	assign cout = inter[3];

	full_adder_4b FA0(.A(A[3:0]),
						.B(B[3:0]), 
						.cin(cin), 
						.Sum(Sum[3:0]), 
						.cout(inter[0])
						);

	full_adder_4b FA1(.A(A[7:4]),
						.B(B[7:4]), 
						.cin(inter[0]), 
						.Sum(Sum[7:4]), 
						.cout(inter[1])
						);

	full_adder_4b FA2(.A(A[11:8]),
						.B(B[11:8]), 
						.cin(inter[1]), 
						.Sum(Sum[11:8]), 
						.cout(inter[2])
						);

	full_adder_4b FA3(.A(A[15:12]),
						.B(B[15:12]), 
						.cin(inter[2]), 
						.Sum(Sum[15:12]), 
						.cout(inter[3])
						);

endmodule
