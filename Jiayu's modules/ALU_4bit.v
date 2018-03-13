module ALU(ALU_Out, Error, ALU_In1, ALU_In2, Opcode);

input[3:0] ALU_In1, ALU_In2;
input[1:0] Opcode; 
output reg[3:0] ALU_Out;
output reg Error; // Just to show overflow

wire[3:0] addsub_out;
wire ovfl; // output of FA1
wire op; 

assign op = Opcode[0];

addsub_4bit FA1(.Result(addsub_out), 
				.Ovfl(ovfl), 
				.A(ALU_In1), 
				.B(ALU_In2), 
				.sub(op)
				);

always @(*) begin
	casex (Opcode)		
		2'b0x : begin  // ADD if 00 and SUB if 01
				ALU_Out = addsub_out;
				Error = ovfl;
				end
		2'b10 : begin  // NAND if 10
				Error = 1'b0;
				ALU_Out = ~(ALU_In1 & ALU_In2);
				end
		2'b11 : begin  // XOR if 11
				Error = 1'b0;
				ALU_Out = ALU_In1 ^ ALU_In2;
				end
		default: begin
				Error = 1'b0;
				ALU_Out = 4'b0; 
				end
	endcase
end

endmodule

module t_ALU;

// inputs to UUT
reg[7:0] stim;
reg[1:0] op;

// outputs of UUT
wire[3:0] ALU_Out;
wire Error;

// Correct results
reg[3:0] correct_out;
reg correct_error;


// instantiate UUT
ALU UUT(.ALU_Out(ALU_Out), 
		.Error(Error), 
		.ALU_In1(stim[3:0]), 
		.ALU_In2(stim[7:4]), 
		.Opcode(op)
		);
	
initial begin
	stim = 0;
	op = 2'b00;
	repeat(100) begin		
		correct_out = stim[3:0] + stim[7:4];
		correct_error = (~(stim[3] ^ stim[7]) & (stim[3] ^ correct_out[3]));
		#20 stim = $random;
		if((ALU_Out !== correct_out) | (Error !== correct_error)) begin
			$display("Incorrect ADD\nA:%b B:%b Result:%b Correct:%b OF:%b Correct:%b", stim[3:0], stim[7:4], ALU_Out, correct_out, Error, correct_error);
			$stop;
			end
	end
	$display("ADD passed\n");
	#10
	
	
	op = 2'b01;
	repeat(100) begin
		correct_out = stim[3:0] - stim[7:4];
		correct_error = ((stim[3] ^ stim[7]) & (stim[3] ^ correct_out[3]));
		#20 stim = $random;
		if((ALU_Out !== correct_out) | (Error !== correct_error)) begin
			$display("Incorrect SUB\n");
			$stop;
			end
	end
	$display("SUB passed\n");
	#10
	
	op = 2'b10;
	repeat(100) begin
		correct_out = ~(stim[3:0] & stim[7:4]);
		correct_error = 1'b0;
		#20 stim = $random;
		if((ALU_Out !== correct_out) | (Error !== correct_error)) begin
			$display("Incorrect NAND\n");
			$stop;
			end
	end
	$display("NAND passed\n");
	#10
	
	op = 2'b11;
	repeat(100) begin
		correct_out = stim[3:0] ^ stim[7:4];
		correct_error = 1'b0;
		#20 stim = $random;
		if((ALU_Out !== correct_out) | (Error !== correct_error)) begin
			$display("Incorrect XOR\n");
			$stop;
			end
	end
	$display("XOR passed\n");
	#10
	
	$stop;

end

endmodule
		
		



































