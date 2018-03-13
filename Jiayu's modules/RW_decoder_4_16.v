module ReadDecoder_4_16(input[3:0] RegId, output[15:0] Wordline);

assign Wordline[0] = (~RegId[3]) & (~RegId[2]) & (~RegId[1]) & (~RegId[0]);
assign Wordline[1] = (~RegId[3]) & (~RegId[2]) & (~RegId[1]) & (RegId[0]);
assign Wordline[2] = (~RegId[3]) & (~RegId[2]) & (RegId[1]) & (~RegId[0]);
assign Wordline[3] = (~RegId[3]) & (~RegId[2]) & (RegId[1]) & (RegId[0]);
assign Wordline[4] = (~RegId[3]) & (RegId[2]) & (~RegId[1]) & (~RegId[0]);
assign Wordline[5] = (~RegId[3]) & (RegId[2]) & (~RegId[1]) & (RegId[0]);
assign Wordline[6] = (~RegId[3]) & (RegId[2]) & (RegId[1]) & (~RegId[0]);
assign Wordline[7] = (~RegId[3]) & (RegId[2]) & (RegId[1]) & (RegId[0]);
assign Wordline[8] = (RegId[3]) & (~RegId[2]) & (~RegId[1]) & (~RegId[0]);
assign Wordline[9] = (RegId[3]) & (~RegId[2]) & (~RegId[1]) & (RegId[0]);
assign Wordline[10] = (RegId[3]) & (~RegId[2]) & (RegId[1]) & (~RegId[0]);
assign Wordline[11] = (RegId[3]) & (~RegId[2]) & (RegId[1]) & (RegId[0]);
assign Wordline[12] = (RegId[3]) & (RegId[2]) & (~RegId[1]) & (~RegId[0]);
assign Wordline[13] = (RegId[3]) & (RegId[2]) & (~RegId[1]) & (RegId[0]);
assign Wordline[14] = (RegId[3]) & (RegId[2]) & (RegId[1]) & (~RegId[0]);
assign Wordline[15] = (RegId[3]) & (RegId[2]) & (RegId[1]) & (RegId[0]);

endmodule


module t_ReadDecoder_4_16;

reg[3:0] stim;
wire[15:0] Out;

ReadDecoder_4_16 UUT(.RegId(stim), 
					.Wordline(Out)
					);

initial begin
	stim = 4'd0;
	#100
	if(Out == 16'h1) $display("Correct for %d\n", stim);
	else begin
		$display("Incorrect for %d\nResult is %b", stim, Out);
		$stop;
		end	
	
	stim = 4'd1;
	#100
	if(Out == 16'h2) $display("Correct for %d\n", stim);
	else begin
		$display("Incorrect for %d\n", stim);
		$stop;
		end
	
	stim = 4'd2;
	#100
	if(Out == 16'h4) $display("Correct for %d\n", stim);
	else begin
		$display("Incorrect for %d\n", stim);
		$stop;
		end
	
	stim = 4'd3;
	#100
	if(Out == 16'h8) $display("Correct for %d\n", stim);
	else begin
		$display("Incorrect for %d\n", stim);
		$stop;
		end
	
	stim = 4'd4;
	#100
	if(Out == 16'h10) $display("Correct for %d\n", stim);
	else begin
		$display("Incorrect for %d\n", stim);
		$stop;
		end
	
	stim = 4'd5;
	#100
	if(Out == 16'h20) $display("Correct for %d\n", stim);
	else begin
		$display("Incorrect for %d\n", stim);
		$stop;
		end
	
	$display("Passed!!!\n");
	#10
	
	$stop;    // stops simulation
end

endmodule


module WriteDecoder_4_16(input[3:0] RegId, input WriteReg, output[15:0] Wordline);

wire x,y,z,w,e;
assign x = RegId[3];
assign y = RegId[2];
assign z = RegId[1];
assign w = RegId[0];
assign e = WriteReg;

assign Wordline[0] = (~x) & (~y) & (~z) & (~w) & (e) ;
assign Wordline[1] = (~x) & (~y) & (~z) & (w) & (e) ;
assign Wordline[2] = (~x) & (~y) & (z) & (~w) & (e) ;
assign Wordline[3] = (~x) & (~y) & (z) & (w) & (e) ;
assign Wordline[4] = (~x) & (y) & (~z) & (~w) & (e) ;
assign Wordline[5] = (~x) & (y) & (~z) & (w) & (e) ;
assign Wordline[6] = (~x) & (y) & (z) & (~w) & (e) ;
assign Wordline[7] = (~x) & (y) & (z) & (w) & (e) ;
assign Wordline[8] = (x) & (~y) & (~z) & (~w) & (e) ;
assign Wordline[9] = (x) & (~y) & (~z) & (w) & (e) ;
assign Wordline[10] = (x) & (~y) & (z) & (~w) & (e) ;
assign Wordline[11] = (x) & (~y) & (z) & (w) & (e) ;
assign Wordline[12] = (x) & (y) & (~z) & (~w) & (e) ;
assign Wordline[13] = (x) & (y) & (~z) & (w) & (e) ;
assign Wordline[14] = (x) & (y) & (z) & (~w) & (e) ;
assign Wordline[15] = (x) & (y) & (z) & (w) & (e) ;

endmodule

module t_WriteDecoder_4_16;

reg[3:0] stim;
reg write;
wire[15:0] Out;

WriteDecoder_4_16 UUT(.RegId(stim),
					.WriteReg(write),
					.Wordline(Out)
					);

initial begin
	write = 0;

	stim = 4'd0;
	#100
	if(Out == 16'h0) $display("Correct for %d\n", stim);
	else begin
		$display("Incorrect for %d\nResult is %b", stim, Out);
		$stop;
		end	
	
	stim = 4'd1;
	#100
	if(Out == 16'h0) $display("Correct for %d\n", stim);
	else begin
		$display("Incorrect for %d\n", stim);
		$stop;
		end
	
	stim = 4'd2;
	#100
	if(Out == 16'h0) $display("Correct for %d\n", stim);
	else begin
		$display("Incorrect for %d\n", stim);
		$stop;
		end
	
	stim = 4'd3;
	#100
	if(Out == 16'h0) $display("Correct for %d\n", stim);
	else begin
		$display("Incorrect for %d\n", stim);
		$stop;
		end
	
	stim = 4'd4;
	#100
	if(Out == 16'h0) $display("Correct for %d\n", stim);
	else begin
		$display("Incorrect for %d\n", stim);
		$stop;
		end
	
	stim = 4'd5;
	#100
	if(Out == 16'h0) $display("Correct for %d\n", stim);
	else begin
		$display("Incorrect for %d\n", stim);
		$stop;
		end
		
	write = 1;
		
	stim = 4'd0;
	#100
	if(Out == 16'h1) $display("Correct for %d\n", stim);
	else begin
		$display("Incorrect for %d\nResult is %b", stim, Out);
		$stop;
		end	
	
	stim = 4'd1;
	#100
	if(Out == 16'h2) $display("Correct for %d\n", stim);
	else begin
		$display("Incorrect for %d\n", stim);
		$stop;
		end
	
	stim = 4'd2;
	#100
	if(Out == 16'h4) $display("Correct for %d\n", stim);
	else begin
		$display("Incorrect for %d\n", stim);
		$stop;
		end
	
	stim = 4'd3;
	#100
	if(Out == 16'h8) $display("Correct for %d\n", stim);
	else begin
		$display("Incorrect for %d\n", stim);
		$stop;
		end
	
	stim = 4'd4;
	#100
	if(Out == 16'h10) $display("Correct for %d\n", stim);
	else begin
		$display("Incorrect for %d\n", stim);
		$stop;
		end
	
	stim = 4'd5;
	#100
	if(Out == 16'h20) $display("Correct for %d\n", stim);
	else begin
		$display("Incorrect for %d\n", stim);
		$stop;
		end
	
	$display("Passed!!!\n");
	#10
	
	$stop;    // stops simulation
end

endmodule