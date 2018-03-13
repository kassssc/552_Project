module Register(input clk,  
				input rst, 
				input[15:0] D, 
				input WriteReg, 
				input ReadEnable1, 
				input ReadEnable2, 
				inout[15:0] Bitline1, 
				inout[15:0] Bitline2
				);

BitCell bc0(.clk(clk),  
			.rst(rst), 
			.D(D[0]), 
			.WriteEnable(WriteReg), 
			.ReadEnable1(ReadEnable1), 
			.ReadEnable2(ReadEnable2), 
			.Bitline1(Bitline1[0]), 
			.Bitline2(Bitline2[0])
			);		

BitCell bc1(.clk(clk),  
			.rst(rst), 
			.D(D[1]), 
			.WriteEnable(WriteReg), 
			.ReadEnable1(ReadEnable1), 
			.ReadEnable2(ReadEnable2), 
			.Bitline1(Bitline1[1]), 
			.Bitline2(Bitline2[1])
			);

BitCell bc2(.clk(clk),  
			.rst(rst), 
			.D(D[2]), 
			.WriteEnable(WriteReg), 
			.ReadEnable1(ReadEnable1), 
			.ReadEnable2(ReadEnable2), 
			.Bitline1(Bitline1[2]), 
			.Bitline2(Bitline2[2])
			);			
				
BitCell bc3(.clk(clk),  
			.rst(rst), 
			.D(D[3]), 
			.WriteEnable(WriteReg), 
			.ReadEnable1(ReadEnable1), 
			.ReadEnable2(ReadEnable2), 
			.Bitline1(Bitline1[3]), 
			.Bitline2(Bitline2[3])
			);				
				
BitCell bc4(.clk(clk),  
			.rst(rst), 
			.D(D[4]), 
			.WriteEnable(WriteReg), 
			.ReadEnable1(ReadEnable1), 
			.ReadEnable2(ReadEnable2), 
			.Bitline1(Bitline1[4]), 
			.Bitline2(Bitline2[4])
			);		

BitCell bc5(.clk(clk),  
			.rst(rst), 
			.D(D[5]), 
			.WriteEnable(WriteReg), 
			.ReadEnable1(ReadEnable1), 
			.ReadEnable2(ReadEnable2), 
			.Bitline1(Bitline1[5]), 
			.Bitline2(Bitline2[5])
			);	

BitCell bc6(.clk(clk),  
			.rst(rst), 
			.D(D[6]), 
			.WriteEnable(WriteReg), 
			.ReadEnable1(ReadEnable1), 
			.ReadEnable2(ReadEnable2), 
			.Bitline1(Bitline1[6]), 
			.Bitline2(Bitline2[6])
			);			
			
BitCell bc7(.clk(clk),  
			.rst(rst), 
			.D(D[7]), 
			.WriteEnable(WriteReg), 
			.ReadEnable1(ReadEnable1), 
			.ReadEnable2(ReadEnable2), 
			.Bitline1(Bitline1[7]), 
			.Bitline2(Bitline2[7])
			);

BitCell bc8(.clk(clk),  
			.rst(rst), 
			.D(D[8]), 
			.WriteEnable(WriteReg), 
			.ReadEnable1(ReadEnable1), 
			.ReadEnable2(ReadEnable2), 
			.Bitline1(Bitline1[8]), 
			.Bitline2(Bitline2[8])
			);

BitCell bc9(.clk(clk),  
			.rst(rst), 
			.D(D[9]), 
			.WriteEnable(WriteReg), 
			.ReadEnable1(ReadEnable1), 
			.ReadEnable2(ReadEnable2), 
			.Bitline1(Bitline1[9]), 
			.Bitline2(Bitline2[9])
			);

BitCell bc10(.clk(clk),  
			.rst(rst), 
			.D(D[10]), 
			.WriteEnable(WriteReg), 
			.ReadEnable1(ReadEnable1), 
			.ReadEnable2(ReadEnable2), 
			.Bitline1(Bitline1[10]), 
			.Bitline2(Bitline2[10])
			);

BitCell bc11(.clk(clk),  
			.rst(rst), 
			.D(D[11]), 
			.WriteEnable(WriteReg), 
			.ReadEnable1(ReadEnable1), 
			.ReadEnable2(ReadEnable2), 
			.Bitline1(Bitline1[11]), 
			.Bitline2(Bitline2[11])
			);

BitCell bc12(.clk(clk),  
			.rst(rst), 
			.D(D[12]), 
			.WriteEnable(WriteReg), 
			.ReadEnable1(ReadEnable1), 
			.ReadEnable2(ReadEnable2), 
			.Bitline1(Bitline1[12]), 
			.Bitline2(Bitline2[12])
			);			

BitCell bc13(.clk(clk),  
			.rst(rst), 
			.D(D[13]), 
			.WriteEnable(WriteReg), 
			.ReadEnable1(ReadEnable1), 
			.ReadEnable2(ReadEnable2), 
			.Bitline1(Bitline1[13]), 
			.Bitline2(Bitline2[13])
			);

BitCell bc14(.clk(clk),  
			.rst(rst), 
			.D(D[14]), 
			.WriteEnable(WriteReg), 
			.ReadEnable1(ReadEnable1), 
			.ReadEnable2(ReadEnable2), 
			.Bitline1(Bitline1[14]), 
			.Bitline2(Bitline2[14])
			);
			
BitCell bc15(.clk(clk),  
			.rst(rst), 
			.D(D[15]), 
			.WriteEnable(WriteReg), 
			.ReadEnable1(ReadEnable1), 
			.ReadEnable2(ReadEnable2), 
			.Bitline1(Bitline1[15]), 
			.Bitline2(Bitline2[15])
			);			
			
endmodule


module t_Register;

reg clk, rst, wen, ren1, ren2;
reg[15:0] d;
wire[15:0] bl1, bl2;

// clock initialization
initial clk = 1'b0;
always clk = #10 ~clk;

Register UUT(.clk(clk),
			.rst(rst),
			.D(d),
			.WriteReg(wen),
			.ReadEnable1(ren1),
			.ReadEnable2(ren2),
			.Bitline1(bl1),
			.Bitline2(bl2)
			);
			
initial begin
	// reset register first
	rst = 1'b1;
	#40	
	rst = 1'b0;
	#40
	
	// give register input
	d = 16'hffff;
	#100
	
	// first write value of FFFF to register
	wen = 1'b1;
	#100
	
	// disable read, check read value
	ren1 = 1'b0;
	#100
	ren2 = 1'b0;
	#100
	wen = 1'b0;
	#100	
	
	$display("bitline1 is %h\n", bl1);
	$display("bitline2 is %h\n", bl2);
		
	// enable read, check read value
	ren1 = 1'b1;
	#100
	ren2 = 1'b1;
	#100	
	
	if(bl1 == 16'hffff) $display("Correct for 1\n");
	else begin
		$display("Incorrect for 1\n");
		$stop;
		end
		
	if(bl2 == 16'hffff) $display("Correct for 2\n");
	else begin
		$display("Incorrect for 2\n");
		$stop;
		end
		
	// input new value, enable write, then check read value	
	d = 16'h0;
	#100
	wen = 1'b1;
	#100
	
	if(bl1 == 16'h0) $display("Correct for 3\n");
	else begin
		$display("Incorrect for 3\n");
		$stop;
		end
		
	if(bl2 == 16'h0) $display("Correct for 4\n");
	else begin
		$display("Incorrect for 4\n");
		$stop;
		end
		
	$display("Passed!!!\n");
	#10
	
	$stop;    // stops simulation		
end


endmodule
