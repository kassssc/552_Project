module Shifter_16bit(Shift_Out, Shift_In, Shift_Val, Mode);

//This is the number to perform shift operation on
input[15:0] Shift_In; 
//Shift amount (used to shift the ‘Shift_In’)
input[3:0] Shift_Val; 
// To indicate SLL(0) or SRA(1)
input  Mode;  
//Shifter value
output[15:0] Shift_Out; 

reg[15:0] sll, sra;

// calculate SLL result
always@(*) begin
	case(Shift_Val)
		0: sll = Shift_In;
		1: sll = {Shift_In[14:0], 1'b0};
		2: sll = {Shift_In[13:0], 2'b0};
		3: sll = {Shift_In[12:0], 3'b0};
		4: sll = {Shift_In[11:0], 4'b0};
		5: sll = {Shift_In[10:0], 5'b0};
		6: sll = {Shift_In[9:0], 6'b0};
		7: sll = {Shift_In[8:0], 7'b0};
		8: sll = {Shift_In[7:0], 8'b0};
		9: sll = {Shift_In[6:0], 9'b0};
		10: sll = {Shift_In[5:0], 10'b0};
		11: sll = {Shift_In[4:0], 11'b0};
		12: sll = {Shift_In[3:0], 12'b0};
		13: sll = {Shift_In[2:0], 13'b0};
		14: sll = {Shift_In[1:0], 14'b0};
		15: sll = {Shift_In[0], 15'b0};
		default : sll = Shift_In;
	endcase
end

// calculate SRA result
always@(*) begin
	case(Shift_Val)
		0: sra = Shift_In;
		1: sra = {Shift_In[15], Shift_In[15:1]};
		2: sra = {{2{Shift_In[15]}}, Shift_In[15:2]};
		3: sra = {{3{Shift_In[15]}}, Shift_In[15:3]};
		4: sra = {{4{Shift_In[15]}}, Shift_In[15:4]};
		5: sra = {{5{Shift_In[15]}}, Shift_In[15:5]};
		6: sra = {{6{Shift_In[15]}}, Shift_In[15:6]};
		7: sra = {{7{Shift_In[15]}}, Shift_In[15:7]};
		8: sra = {{8{Shift_In[15]}}, Shift_In[15:8]};
		9: sra = {{9{Shift_In[15]}}, Shift_In[15:9]};
		10: sra = {{10{Shift_In[15]}}, Shift_In[15:10]};
		11: sra = {{11{Shift_In[15]}}, Shift_In[15:11]};
		12: sra = {{12{Shift_In[15]}}, Shift_In[15:12]};
		13: sra = {{13{Shift_In[15]}}, Shift_In[15:13]};
		14: sra = {{14{Shift_In[15]}}, Shift_In[15:14]};
		15: sra = {{15{Shift_In[15]}}, Shift_In[15]};
		default : sra = Shift_In;
	endcase
end

// Mode 0 for SLL and 1 for SRA
assign Shift_Out = Mode? sra:sll;

endmodule


module t_Shifter_16bit;

reg [15:0] Shift_In; //This is the number to perform shift operation on
reg [3:0] Shift_Val; //Shift amount (used to shift the ‘Shift_In’)
reg  Mode; // To indicate SLL(0) or SRA(1) 
wire [15:0] Shift_Out; //Shifter value

Shifter_16bit UUT(.Shift_Out(Shift_Out), 
		.Shift_In(Shift_In), 
		.Shift_Val(Shift_Val), 
		.Mode(Mode)
		);

initial begin
	// test for SLL
	Mode = 0;
	Shift_In = 16'b1;
	
	Shift_Val =  4'd0;
	#100
	if(Shift_Out == 16'd1) $display("SLL success for %d-bit shift\n", Shift_Val);
	else begin
		$display("SLL failed for %d-bit shift\n", Shift_Val);
		$stop;
		end
	
	Shift_Val = 4'd1;
	#100
	if(Shift_Out == 16'd2) $display("SLL success for %d-bit shift\n", Shift_Val);
	else begin
		$display("SLL failed for %d-bit shift\n", Shift_Val);
		$stop;
		end
		
	Shift_Val = 4'd2;
	#100
	if(Shift_Out == 16'd4) $display("SLL success for %d-bit shift\n", Shift_Val);
	else begin 
		$display("SLL failed for %d-bit shift\n", Shift_Val);
		$stop;
		end
		
	Shift_Val = 4'd3;
	#100
	if(Shift_Out == 16'd8) $display("SLL success for %d-bit shift\n", Shift_Val);
	else begin
		$display("SLL failed for %d-bit shift\n", Shift_Val);
		$stop;
		end
		
	Shift_Val = 4'd4;
	#100
	if(Shift_Out == 16'h10) $display("SLL success for %d-bit shift\n", Shift_Val);
	else begin
		$display("SLL failed for %d-bit shift\n", Shift_Val);	
		$stop;
		end		
		
	Shift_Val = 4'd5;
	#100
	if(Shift_Out == 16'h20) $display("SLL success for %d-bit shift\n", Shift_Val);
	else begin
		$display("SLL failed for %d-bit shift\n", Shift_Val);	
		$stop;
		end		
		
	Shift_Val = 4'd6;
	#100
	if(Shift_Out == 16'h40) $display("SLL success for %d-bit shift\n", Shift_Val);
	else begin
		$display("SLL failed for %d-bit shift\n", Shift_Val);	
		$stop;
		end		
		
	Shift_Val = 4'd7;
	#100
	if(Shift_Out == 16'h80) $display("SLL success for %d-bit shift\n", Shift_Val);
	else begin
		$display("SLL failed for %d-bit shift\n", Shift_Val);	
		$stop;
		end		
		
	Shift_Val = 4'd8;
	#100
	if(Shift_Out == 16'h100) $display("SLL success for %d-bit shift\n", Shift_Val);
	else begin
		$display("SLL failed for %d-bit shift\n", Shift_Val);	
		$stop;
		end		
		
	Shift_Val = 4'd9;
	#100
	if(Shift_Out == 16'h200) $display("SLL success for %d-bit shift\n", Shift_Val);
	else begin
		$display("SLL failed for %d-bit shift\n", Shift_Val);	
		$stop;
		end		
		
	Shift_Val = 4'd10;
	#100
	if(Shift_Out == 16'h400) $display("SLL success for %d-bit shift\n", Shift_Val);
	else begin
		$display("SLL failed for %d-bit shift\n", Shift_Val);	
		$stop;
		end		
	
	Shift_Val = 4'd11;
	#100
	if(Shift_Out == 16'h800) $display("SLL success for %d-bit shift\n", Shift_Val);
	else begin
		$display("SLL failed for %d-bit shift\n", Shift_Val);	
		$stop;
		end		
	
	Shift_Val = 4'd12;
	#100
	if(Shift_Out == 16'h1000) $display("SLL success for %d-bit shift\n", Shift_Val);
	else begin
		$display("SLL failed for %d-bit shift\n", Shift_Val);	
		$stop;
		end		
	
	Shift_Val = 4'd13;
	#100
	if(Shift_Out == 16'h2000) $display("SLL success for %d-bit shift\n", Shift_Val);
	else begin
		$display("SLL failed for %d-bit shift\n", Shift_Val);	
		$stop;
		end	
	
	Shift_Val = 4'd14;
	#100
	if(Shift_Out == 16'h4000) $display("SLL success for %d-bit shift\n", Shift_Val);
	else begin
		$display("SLL failed for %d-bit shift\n", Shift_Val);	
		$stop;
		end	
	
	Shift_Val = 4'd15;
	#100
	if(Shift_Out == 16'h8000) $display("SLL success for %d-bit shift\n", Shift_Val);
	else begin
		$display("SLL failed for %d-bit shift\n", Shift_Val);	
		$stop;
		end	
	
	
	// test for SRA 
	Mode = 1;
	Shift_In = 16'h8000;
	
	Shift_Val =  4'd0;
	#100
	if(Shift_Out == 16'h8000) $display("SRA success for %d-bit shift\n", Shift_Val);
	else begin
		$display("SRA failed for %d-bit shift\n", Shift_Val);
		$stop;
		end
	
	Shift_Val =  4'd1;
	#100
	if(Shift_Out == 16'hc000) $display("SRA success for %d-bit shift\n", Shift_Val);
	else begin
		$display("SRA failed for %d-bit shift\n", Shift_Val);
		$stop;
		end
	
	Shift_Val =  4'd2;
	#100
	if(Shift_Out == 16'he000) $display("SRA success for %d-bit shift\n", Shift_Val);
	else begin
		$display("SRA failed for %d-bit shift\n", Shift_Val);
		$stop;
		end
		
	Shift_Val =  4'd3;
	#100
	if(Shift_Out == 16'hf000) $display("SRA success for %d-bit shift\n", Shift_Val);
	else begin
		$display("SRA failed for %d-bit shift\n", Shift_Val);
		$stop;
		end
		
	Shift_Val =  4'd4;
	#100
	if(Shift_Out == 16'hf800) $display("SRA success for %d-bit shift\n", Shift_Val);
	else begin
		$display("SRA failed for %d-bit shift\n", Shift_Val);
		$stop;
		end	
		
	Shift_Val =  4'd5;
	#100
	if(Shift_Out == 16'hfc00) $display("SRA success for %d-bit shift\n", Shift_Val);
	else begin
		$display("SRA failed for %d-bit shift\n", Shift_Val);
		$stop;
		end	
	
	Shift_Val =  4'd6;
	#100
	if(Shift_Out == 16'hfe00) $display("SRA success for %d-bit shift\n", Shift_Val);
	else begin
		$display("SRA failed for %d-bit shift\n", Shift_Val);
		$stop;
		end
	
	Shift_Val =  4'd7;
	#100
	if(Shift_Out == 16'hff00) $display("SRA success for %d-bit shift\n", Shift_Val);
	else begin
		$display("SRA failed for %d-bit shift\n", Shift_Val);
		$stop;
		end
	
	Shift_Val =  4'd8;
	#100
	if(Shift_Out == 16'hff80) $display("SRA success for %d-bit shift\n", Shift_Val);
	else begin
		$display("SRA failed for %d-bit shift\n", Shift_Val);
		$stop;
		end
	
	Shift_Val =  4'd9;
	#100
	if(Shift_Out == 16'hffc0) $display("SRA success for %d-bit shift\n", Shift_Val);
	else begin
		$display("SRA failed for %d-bit shift\n", Shift_Val);
		$stop;
		end
	
	Shift_Val =  4'd10;
	#100
	if(Shift_Out == 16'hffe0) $display("SRA success for %d-bit shift\n", Shift_Val);
	else begin
		$display("SRA failed for %d-bit shift\n", Shift_Val);
		$stop;
		end
	
	Shift_Val =  4'd11;
	#100
	if(Shift_Out == 16'hfff0) $display("SRA success for %d-bit shift\n", Shift_Val);
	else begin
		$display("SRA failed for %d-bit shift\n", Shift_Val);
		$stop;
		end
	
	Shift_Val =  4'd12;
	#100
	if(Shift_Out == 16'hfff8) $display("SRA success for %d-bit shift\n", Shift_Val);
	else begin
		$display("SRA failed for %d-bit shift\n", Shift_Val);
		$stop;
		end
	
	Shift_Val =  4'd13;
	#100
	if(Shift_Out == 16'hfffc) $display("SRA success for %d-bit shift\n", Shift_Val);
	else begin
		$display("SRA failed for %d-bit shift\n", Shift_Val);
		$stop;
		end
	
	Shift_Val =  4'd14;
	#100
	if(Shift_Out == 16'hfffe) $display("SRA success for %d-bit shift\n", Shift_Val);
	else begin
		$display("SRA failed for %d-bit shift\n", Shift_Val);
		$stop;
		end
	
	Shift_Val =  4'd15;
	#100
	if(Shift_Out == 16'hffff) $display("SRA success for %d-bit shift\n", Shift_Val);
	else begin
		$display("SRA failed for %d-bit shift\n", Shift_Val);
		$stop;
		end
	
	$display("Passed!!!\n");
	#20
	
	$stop;	
end

endmodule






