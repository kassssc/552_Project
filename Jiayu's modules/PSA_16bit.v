module PSA_16bit(Sum, Error, A, B);
// perform 16 bit parallel sub-word addition
// overflow in any addition causes Error to be 1

input[15:0] A, B; //Input values
output[15:0] Sum; //sum output
output Error; //To indicate overflows

wire[3:0] Ovfl;

addsub_4bit l1(.Result(Sum[3:0]), 
				.Ovfl(Ovfl[0]), 
				.A(A[3:0]), 
				.B(B[3:0]), 
				.sub(1'b0)
				);
				
addsub_4bit l2(.Result(Sum[7:4]), 
				.Ovfl(Ovfl[1]), 
				.A(A[7:4]), 
				.B(B[7:4]), 
				.sub(1'b0)
				);			

addsub_4bit h1(.Result(Sum[11:8]), 
				.Ovfl(Ovfl[2]), 
				.A(A[11:8]), 
				.B(B[11:8]), 
				.sub(1'b0)
				);

addsub_4bit h2(.Result(Sum[15:12]), 
				.Ovfl(Ovfl[3]), 
				.A(A[15:12]), 
				.B(B[15:12]), 
				.sub(1'b0)
				);
				
assign Error = Ovfl[0] | Ovfl[1] | Ovfl[2] | Ovfl[3];

endmodule


module t_PSA_16bit;

// input to UUT are regs
reg[15:0] stimA, stimB; 
// outputs of UUT are wires
wire[15:0] Sum; 
wire err;
// correct answer
reg[3:0] l1s_correct, l2s_correct, h1s_correct, h2s_correct; 
wire[3:0] ovfl_correct;

//My overflow logic, to check against the design's overflow logic
assign ovfl_correct[0] = (~(stimA[3] ^ stimB[3]) & (stimA[3] ^ l1s_correct[3]));
assign ovfl_correct[1] = (~(stimA[7] ^ stimB[7]) & (stimA[7] ^ l2s_correct[3]));
assign ovfl_correct[2] = (~(stimA[11] ^ stimB[11]) & (stimA[11] ^ h1s_correct[3]));
assign ovfl_correct[3] = (~(stimA[15] ^ stimB[15]) & (stimA[15] ^ h2s_correct[3]));
	
// instantiate UUT
PSA_16bit UUT(.Sum(Sum), 
				.Error(err), 
				.A(stimA[15:0]),
				.B(stimB[15:0])
				);


// stimulus generation
initial begin
	stimA = 16'b0;
	stimB = 16'b0;
	
	repeat(100) begin //Do this for 100 different inputs
		l1s_correct[3:0] = stimA[3:0] + stimB[3:0];
		l2s_correct[3:0] = stimA[7:4] + stimB[7:4];
		h1s_correct[3:0] = stimA[11:8] + stimB[11:8];
		h2s_correct[3:0] = stimA[15:12] + stimB[15:12];
		#20 begin
			stimA = $random;
			stimB = $random;
			end
		if(err == (ovfl_correct[0] | ovfl_correct[1] | ovfl_correct[2] | ovfl_correct[3])) 
			$display("Correct for OF\n"); //Print correct if my logic matches design
		else begin
			$display("Incorrect for OF\n"); //Else print incorrect
			$display("A:%h\nA[0]:%b\nB:%h\nB[0]:%b\nSum:%h\nSum[1]:%b\nSum_correct:%h %h %h %h\nOF:%b\nErr:%b\n", stimA[15:0], stimA[0], stimB[15:0], stimB[0], Sum[15:0], Sum[1], l1s_correct[3:0], l2s_correct[3:0], h1s_correct[3:0], h2s_correct[3:0], ovfl_correct[3:0], err);
			$stop;
			end
		if(l1s_correct == Sum[3:0] || l2s_correct == Sum[7:4] || h1s_correct == Sum[11:8] || h2s_correct == Sum[15:12]) $display("Correct for sum result\n");
		else begin
			$display("Incorrect sum result\n");
			$stop;
			end
	end
	
	$display("Passed!!!\n");
	#10
	
	$stop;    // stops simulation
end

endmodule
