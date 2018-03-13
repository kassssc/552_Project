module PC_control(input[2:0] C, 
				input[8:0] I, 
				input[2:0] F, 
				input[15:0] PC_in, 
				output[15:0] PC_out
				);

wire[15:0] normal, branch;
wire[1:0] e;
reg[15:0] out;

// calculate normal PC increment
full_adder_16bit add1(.A(PC_in),
					.B(16'd2), 
					.Cin(1'b0), 
					.Sum(normal), 
					.Cout(e[0])
					);

				
// calculate branch address		
full_adder_16bit add2(.A(normal),
					.B({16{I<<1}}), 
					.Cin(e[0]), 
					.Sum(branch), 
					.Cout(e[1])
					);					

assign PC_out = out;
always@(*) begin
	case(C)	
		// F bits from MSB to LSB is Z, V, N
		3'b000: assign out = (F[2] == 1'b0)? branch : normal;
		3'b001: assign out = (F[2] == 1'b1)? branch : normal;  
		3'b010: assign out = (F[2] == 1'b1)? normal : (F[0] == 1'b0)? branch : normal;  	
		3'b011: assign out = (F[0] == 1'b1)? branch : normal;  
		3'b100: assign out = (F[2] == 1'b1)? branch : (F[0] == 1'b0)? branch : normal;
		3'b101: assign out = (F[2] == 1'b1)? branch : (F[0] == 1'b1)? branch : normal;
		3'b110: assign out = (F[1] == 1'b1)? branch : normal;
		3'b111: assign out = branch;
		default: assign out = normal;
	endcase
end
		
endmodule


module t_PC_control;

reg[2:0] c,f;
reg[8:0] i;
reg[15:0] stim;
wire[15:0] out, branch, normal;

PC_control UUT(.C(c), 
			.I(i), 
			.F(f), 
			.PC_in(stim), 
			.PC_out(out)
			);
			
assign branch = stim + 2 + {16{i<<1}};
assign normal = stim + 2;
			
initial begin
	stim = 16'hf321;
	i = 9'h45;
	
	// start with condition code 000
	// make flag meet and not-meet condition
	c = 3'b000;
	f = 3'b011;
	#200
	if(out == branch) $display("Correct for condition:%ba\n", c);
	else begin
		$display("Incorrect for condition:%ba\nout:%h\nbranch:%h\nnormal:%h\n", c, out, branch, normal);
		$stop;
		end		
	f = 3'b110;
	#100
	if(out == normal) $display("Correct for condition:%bb\nout:%h\n", c, out);
	else begin
		$display("Incorrect for condition:%bb\n", c);
		$stop;
		end
	
	// condition code 001
	c = 3'b001;
	f = 3'b110;
	#100
	if(out == branch) $display("Correct for condition:%ba\n", c);
	else begin
		$display("Incorrect for condition:%ba\nout:%h\nbranch:%h\nnormal:%h\n", c, out, branch, normal);
		$stop;
		end		
	f = 3'b011;
	#100
	if(out == normal) $display("Correct for condition:%bb\n", c);
	else begin
		$display("Incorrect for condition:%bb\n", c);
		$stop;
		end
		
	// condition code 010
	c = 3'b010;
	f = 3'b010;
	#100
	if(out == branch) $display("Correct for condition:%ba\n", c);
	else begin
		$display("Incorrect for condition:%ba\n", c);
		$stop;
		end		
	f = 3'b011;
	#100
	if(out == normal) $display("Correct for condition:%bb\n", c);
	else begin
		$display("Incorrect for condition:%bb\n", c);
		$stop;
		end	
	f = 3'b100;
	#100
	if(out == normal) $display("Correct for condition:%bc\n", c);
	else begin
		$display("Incorrect for condition:%bc\n", c);
		$stop;
		end	
		
	// condition code 011
	c = 3'b011;
	f = 3'b101;
	#100
	if(out == branch) $display("Correct for condition:%ba\n", c);
	else begin
		$display("Incorrect for condition:%ba\nout:%h\nbranch:%h\nnormal:%h\n", c, out, branch, normal);
		$stop;
		end		
	f = 3'b100;
	#100
	if(out == normal) $display("Correct for condition:%bb\n", c);
	else begin
		$display("Incorrect for condition:%bb\nout:%h\nbranch:%h\nnormal:%h\n", c, out, branch, normal);
		$stop;
		end	
		
	// condition code 100
	c = 3'b100;
	f = 3'b110;
	#100
	if(out == branch) $display("Correct for condition:%ba\n", c);
	else begin
		$display("Incorrect for condition:%ba\n", c);
		$stop;
		end		
	f = 3'b111;
	#100
	if(out == branch) $display("Correct for condition:%bb\n", c);
	else begin
		$display("Incorrect for condition:%bb\n", c);
		$stop;
		end	
	f = 3'b000;
	#100
	if(out == branch) $display("Correct for condition:%bc\n", c);
	else begin
		$display("Incorrect for condition:%bc\n", c);
		$stop;
		end	
	f = 3'b011;
	#100
	if(out == normal) $display("Correct for condition:%bd\n", c);
	else begin
		$display("Incorrect for condition:%bd\n", c);
		$stop;
		end	
		
	// condition code 101
	c = 3'b101;
	f = 3'b110;
	#100
	if(out == branch) $display("Correct for condition:%ba\n", c);
	else begin
		$display("Incorrect for condition:%ba\n", c);
		$stop;
		end		
	f = 3'b011;
	#100
	if(out == branch) $display("Correct for condition:%bb\n", c);
	else begin
		$display("Incorrect for condition:%bb\n", c);
		$stop;
		end	
	f = 3'b101;
	#100
	if(out == branch) $display("Correct for condition:%bc\n", c);
	else begin
		$display("Incorrect for condition:%bc\n", c);
		$stop;
		end	
	f = 3'b010;
	#100
	if(out == normal) $display("Correct for condition:%bd\n", c);
	else begin
		$display("Incorrect for condition:%bd\n", c);
		$stop;
		end	
		
	// condition code 110
	c = 3'b110;
	f = 3'b010;
	#100
	if(out == branch) $display("Correct for condition:%ba\n", c);
	else begin
		$display("Incorrect for condition:%ba\n", c);
		$stop;
		end		
	f = 3'b001;
	#100
	if(out == normal) $display("Correct for condition:%bb\n", c);
	else begin
		$display("Incorrect for condition:%bb\n", c);
		$stop;
		end	
		
	// condition code 111
	c = 3'b111;
	f = 3'b010;
	#100
	if(out == branch) $display("Correct for condition:%ba\n", c);
	else begin
		$display("Incorrect for condition:%ba\n", c);
		$stop;
		end		
	f = 3'b101;
	#100
	if(out == branch) $display("Correct for condition:%bb\n", c);
	else begin
		$display("Incorrect for condition:%bb\n", c);
		$stop;
		end			
	
	$display("Passed!!!\n");
	#10
	
	$stop;    // stops simulation
end


endmodule