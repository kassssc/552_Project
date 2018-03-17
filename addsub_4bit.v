module addsub_4bit(Result, Ovfl, A, B, sub);

input[3:0] A, B;
input sub;
output[3:0] Result;
output reg Ovfl;

wire[4:1] C;
reg[3:0] BB;

always @(*) begin
	casex (sub)
		1'b0 : begin // ADD operation
				BB = B;
				Ovfl = (Result[3] & ~A[3] & ~B[3]) | (~Result[3] & A[3] & B[3]);
				end
				
		1'b1 : begin // SUB operation
				BB = ~B;
				Ovfl = (Result[3] & ~A[3] & B[3]) | (~Result[3] & A[3] & ~B[3]);
				end			
	endcase
end

full_adder_1bit FA1(.A(A[0]),
					.B(BB[0]), 
					.Cin(sub), 
					.S(Result[0]), 
					.Cout(C[1])
					);

full_adder_1bit FA2(.A(A[1]),
					.B(BB[1]), 
					.Cin(C[1]), 
					.S(Result[1]), 
					.Cout(C[2])
					);

full_adder_1bit FA3(.A(A[2]),
					.B(BB[2]), 
					.Cin(C[2]), 
					.S(Result[2]), 
					.Cout(C[3])
					);   

full_adder_1bit FA4(.A(A[3]),
					.B(BB[3]), 
					.Cin(C[3]), 
					.S(Result[3]), 
					.Cout(C[4])
					); 

endmodule

module t_addsub4b;

reg[7:0] stim;    // inputs to UUT are regs
reg[3:0] sum_correct, sub_correct;
reg sub;
wire[3:0] R;  // outputs of UUT are wires
wire ovfl, ovflsum_correct, ovflsub_correct;

//My overflow logic, to check against the design's overflow logic
assign ovflsum_correct = (~(stim[3] ^ stim[7]) & (stim[3] ^ R[3]));
assign ovflsub_correct = ((stim[3] ^ stim[7]) & (stim[3] ^ R[3])); 
	
// instantiate UUT
addsub_4bit UUT(.Result(R), 
				.Ovfl(ovfl), 
				.A(stim[3:0]), 
				.B(stim[7:4]), 
				.sub(sub)
				);

// stimulus generation
initial begin
	stim = 0;
	sub = 1'b0;
	repeat(100) begin //Do this for 100 different inputs
		sum_correct = stim[3:0] + stim[7:4];
		#20 stim = $random;
		if(ovfl == ovflsum_correct) $display("Correct for OF\n"); //Print correct if my logic matches design
		else begin
			$display("Incorrect for OF\n"); //Else print incorrect
			$stop;
			end
		if(sum_correct == R) $display("Correct for Add\n");
		else begin
			$display("Incorrect Add\n");
			$stop;
			end
	end
	$display("Add passed\n");
	#10
	
	sub = 1'b1;
	repeat(100) begin //Do this for 100 different inputs
		sub_correct = stim[3:0] - stim[7:4];
		#20 stim = $random;
		if(ovfl == ovflsub_correct) $display("Correct for OF\n"); //Print correct if my logic matches design
		else begin
			$display("Incorrect for OF\n"); //Else print incorrect
			$display("A:%b B:%b OF:%b correct:%b Result:%b correct:%b\n", stim[3:0], stim[7:4], ovfl, ovflsub_correct, R, sub_correct);
			$stop;
			end
		if(sub_correct == R) $display("Correct for Sub\n");
		else begin
			$display("Incorrect Sub\n");
			$stop;
			end
	end
	$display("Sub passed\n");
	#10 
	
	$stop;    // stops simulation
end

endmodule




