module RegisterFile(input clk, 
					input rst, 
					input[3:0] SrcReg1, 
					input[3:0] SrcReg2, 
					input[3:0] DstReg, 
					input WriteReg, 
					input[15:0] DstData, 
					inout[15:0] SrcData1, 
					inout[15:0] SrcData2
					);

wire[15:0] rd1, rd2, wt, bl1out, bl2out; 
wire[15:0] bl1[15:0];
wire[15:0] bl2[15:0];

assign bl1out = bl1[0] | bl1[1] | bl1[2] | bl1[3] 
				| bl1[4] | bl1[5] | bl1[6] | bl1[7] 
				| bl1[8] | bl1[9] | bl1[10] | bl1[11] 
				| bl1[12] | bl1[13] | bl1[14] | bl1[15];
assign bl2out = bl2[0] | bl2[1] | bl2[2] | bl2[3] 
				| bl2[4] | bl2[5] | bl2[6] | bl2[7] 
				| bl2[8] | bl2[9] | bl2[10] | bl2[11] 
				| bl2[12] | bl2[13] | bl2[14] | bl2[15];
				
assign SrcData1 = (WriteReg & (SrcReg1 == DstReg))? DstData : bl1out;
assign SrcData2 = (WriteReg & (SrcReg2 == DstReg))? DstData : bl2out;		
					
// decode register address					
ReadDecoder_4_16 RD1(.RegId(SrcReg1), 
					.Wordline(rd1)
					);		

ReadDecoder_4_16 RD2(.RegId(SrcReg2), 
					.Wordline(rd2)
					);		

WriteDecoder_4_16 WD(.RegId(DstReg),
					.WriteReg(WriteReg),
					.Wordline(wt)
					);						

// use 16 registers					
Register regis0(.clk(clk),
				.rst(rst),
				.D(DstData),
				.WriteReg(wt[0]),
				.ReadEnable1(rd1[0]),
				.ReadEnable2(rd2[0]),
				.Bitline1(bl1[0]),
				.Bitline2(bl2[0])
				);					
					
Register regis1(.clk(clk),
				.rst(rst),
				.D(DstData),
				.WriteReg(wt[1]),
				.ReadEnable1(rd1[1]),
				.ReadEnable2(rd2[1]),
				.Bitline1(bl1[1]),
				.Bitline2(bl2[1])
				);				
					
Register regis2(.clk(clk),
				.rst(rst),
				.D(DstData),
				.WriteReg(wt[2]),
				.ReadEnable1(rd1[2]),
				.ReadEnable2(rd2[2]),
				.Bitline1(bl1[2]),
				.Bitline2(bl2[2])
				);				
					
Register regis3(.clk(clk),
				.rst(rst),
				.D(DstData),
				.WriteReg(wt[3]),
				.ReadEnable1(rd1[3]),
				.ReadEnable2(rd2[3]),
				.Bitline1(bl1[3]),
				.Bitline2(bl2[3])
				);						
					
Register regis4(.clk(clk),
				.rst(rst),
				.D(DstData),
				.WriteReg(wt[4]),
				.ReadEnable1(rd1[4]),
				.ReadEnable2(rd2[4]),
				.Bitline1(bl1[4]),
				.Bitline2(bl2[4])
				);						
					
Register regis5(.clk(clk),
				.rst(rst),
				.D(DstData),
				.WriteReg(wt[5]),
				.ReadEnable1(rd1[5]),
				.ReadEnable2(rd2[5]),
				.Bitline1(bl1[5]),
				.Bitline2(bl2[5])
				);						
					
Register regis6(.clk(clk),
				.rst(rst),
				.D(DstData),
				.WriteReg(wt[6]),
				.ReadEnable1(rd1[6]),
				.ReadEnable2(rd2[6]),
				.Bitline1(bl1[6]),
				.Bitline2(bl2[6])
				);						
					
Register regis7(.clk(clk),
				.rst(rst),
				.D(DstData),
				.WriteReg(wt[7]),
				.ReadEnable1(rd1[7]),
				.ReadEnable2(rd2[7]),
				.Bitline1(bl1[7]),
				.Bitline2(bl2[7])
				);						
					
Register regis8(.clk(clk),
				.rst(rst),
				.D(DstData),
				.WriteReg(wt[8]),
				.ReadEnable1(rd1[8]),
				.ReadEnable2(rd2[8]),
				.Bitline1(bl1[8]),
				.Bitline2(bl2[8])
				);						

Register regis9(.clk(clk),
				.rst(rst),
				.D(DstData),
				.WriteReg(wt[9]),
				.ReadEnable1(rd1[9]),
				.ReadEnable2(rd2[9]),
				.Bitline1(bl1[9]),
				.Bitline2(bl2[9])
				);	

Register regis10(.clk(clk),
				.rst(rst),
				.D(DstData),
				.WriteReg(wt[10]),
				.ReadEnable1(rd1[10]),
				.ReadEnable2(rd2[10]),
				.Bitline1(bl1[10]),
				.Bitline2(bl2[10])
				);

Register regis11(.clk(clk),
				.rst(rst),
				.D(DstData),
				.WriteReg(wt[11]),
				.ReadEnable1(rd1[11]),
				.ReadEnable2(rd2[11]),
				.Bitline1(bl1[11]),
				.Bitline2(bl2[11])
				);
				
Register regis12(.clk(clk),
				.rst(rst),
				.D(DstData),
				.WriteReg(wt[12]),
				.ReadEnable1(rd1[12]),
				.ReadEnable2(rd2[12]),
				.Bitline1(bl1[12]),
				.Bitline2(bl2[12])
				);				

Register regis13(.clk(clk),
				.rst(rst),
				.D(DstData),
				.WriteReg(wt[13]),
				.ReadEnable1(rd1[13]),
				.ReadEnable2(rd2[13]),
				.Bitline1(bl1[13]),
				.Bitline2(bl2[13])
				);

Register regis14(.clk(clk),
				.rst(rst),
				.D(DstData),
				.WriteReg(wt[14]),
				.ReadEnable1(rd1[14]),
				.ReadEnable2(rd2[14]),
				.Bitline1(bl1[14]),
				.Bitline2(bl2[14])
				);
				
Register regis15(.clk(clk),
				.rst(rst),
				.D(DstData),
				.WriteReg(wt[15]),
				.ReadEnable1(rd1[15]),
				.ReadEnable2(rd2[15]),
				.Bitline1(bl1[15]),
				.Bitline2(bl2[15])
				);
				
endmodule


module t_RegisterFile;

reg clk, rst, wen;
reg[3:0] rdreg1, rdreg2, wtreg;
reg[15:0] wtdata;
wire[15:0] out1, out2;

// clock initialization
initial clk = 1'b0;
always clk = #10 ~clk;

RegisterFile UUT(.clk(clk), 
				.rst(rst), 
				.SrcReg1(rdreg1), 
				.SrcReg2(rdreg2), 
				.DstReg(wtreg), 
				.WriteReg(wen), 
				.DstData(wtdata), 
				.SrcData1(out1), 
				.SrcData2(out2)
				);

initial begin
	// reset register file first
	rst = 1'b1;
	#40	
	rst = 1'b0;
	#40
	wen = 1'b0;
	#40
	
	//write value of 0xFFFF to register_15
	wtdata = 16'hffff;
	#100
	wtreg = 4'hf;
	#100
	wen = 1'b1;
	#100
	wen = 1'b0;
	#100
	
	//write value of 0x0 to register_0
	wtdata = 16'h0;
	#100
	wtreg = 4'h0;
	#100
	wen = 1'b1;
	#100
	wen = 1'b0;
	#100
	
	// read value from register_0 and register_15
	rdreg1 = 4'h0;
	#100
	rdreg2 = 4'hf;
	#100
	if(out1 == 16'h0) $display("Correct for reg0\n");
	else begin
		$display("Incorrect for reg0\nout1 is %h\n", out1);
		$stop;
		end
		
	if(out2 == 16'hffff) $display("Correct for reg15\n");
	else begin
		$display("Incorrect for reg15\nout2 is %h\n", out2);
		$stop;
		end
	
	//write value of 0x1234 to register_1
	wtdata = 16'h1234;
	#100
	wtreg = 4'h1;
	#100
	wen = 1'b1;
	#100
	wen = 1'b0;
	#100
	
	//write value of 0x4321 to register_2
	wtdata = 16'h4321;
	#100
	wtreg = 4'h2;
	#100
	wen = 1'b1;
	#100
	wen = 1'b0;
	#100
	
	// read value from register_1 and register_2
	rdreg1 = 4'h1;
	#100
	rdreg2 = 4'h2;
	#100	
	if(out1 == 16'h1234) $display("Correct for reg1\n");
	else begin
		$display("Incorrect for reg1\nout1 is %h\n", out1);
		$stop;
		end
		
	if(out2 == 16'h4321) $display("Correct for reg2\n");
	else begin
		$display("Incorrect for reg2\nout2 is %h\n", out2);
		$stop;
		end
		
	// write 0xf00f to register_0	
	wtdata = 16'hf00f;
	#100
	wtreg = 16'h0;
	#100
	wen = 1'b1;
	#100
		
	// read value from register_0 and register_15
	rdreg1 = 4'h0;
	#100
	rdreg2 = 4'hf;
	#100
	
	if(out1 == 16'hf00f) $display("Correct for reg0\n");
	else begin
		$display("Incorrect for reg0\n");
		$stop;
		end
		
	if(out2 == 16'hffff) $display("Correct for reg15\n");
	else begin
		$display("Incorrect for reg15\n");
		$stop;
		end
	
	// write 0x8765 to register_5		
	wen = 1'b0;
	#100
	wtdata = 16'h8765;
	#100
	wtreg = 4'h5;
	#100
	wen = 1'b1;
	#100	
	
	// write 0xabcd to register_9
	wen = 1'b0;
	#100	
	wtdata = 16'habcd;
	#100
	wtreg = 4'h9;
	#100
	wen = 1'b1;
	#100
		
	// read value from register_5 and register_9
	rdreg1 = 4'h5;
	#100
	rdreg2 = 4'h9;
	#100	
	if(out1 == 16'h8765) $display("Correct for reg5\n");
	else begin
		$display("Incorrect for reg5\n");
		$stop;
		end
		
	if(out2 == 16'habcd) $display("Correct for reg9\n");
	else begin
		$display("Incorrect for reg9\n");
		$stop;
		end
		
	$display("Passed!!!\n");
	#10
	
	$stop;    // stops simulation		
end

endmodule