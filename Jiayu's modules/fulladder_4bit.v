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