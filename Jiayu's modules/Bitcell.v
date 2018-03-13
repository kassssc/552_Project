module BitCell(
		input clk,  
		input rst, 
		input D, 
		input WriteEnable, 
		input ReadEnable1, 
		input ReadEnable2, 
		inout Bitline1, 
		inout Bitline2
		);

wire q;

dff ff(.q(q), 
		.d(D), 
		.wen(WriteEnable), 
		.clk(clk), 
		.rst(rst)
		);

// if ReadEnable is 1, then output DFF value, otherwise always 0
assign Bitline1 = ReadEnable1? q : 1'b0;
assign Bitline2 = ReadEnable2? q : 1'b0;

endmodule


module t_BitCell;

reg clk, rst, d, wen, ren1, ren2;
wire bl1, bl2;

// clock initialization
initial clk = 1'b0;
always clk = #10 ~clk;

BitCell bc(.clk(clk),  
			.rst(rst), 
			.D(d), 
			.WriteEnable(wen), 
			.ReadEnable1(ren1), 
			.ReadEnable2(ren2), 
			.Bitline1(bl1), 
			.Bitline2(bl2)
			);

initial begin
	// reset DFF first
	rst = 1'b1;
	#40
	
	rst = 1'b0;
	#40
	
	// give DFF input
	d = 1'b1;
	#100
	
	// first write value of 1 to DFF
	wen = 1'b1;
	#100
	
	// disable read, check read value
	ren1 = 1'b0;
	#100
	ren2 = 1'b0;
	#100
	wen = 1'b0;
	#100	
	
	$display("bitline1 is %b\n", bl1);
	$display("bitline2 is %b\n", bl2);
		
	// enable read, check read value
	ren1 = 1'b1;
	#100
	ren2 = 1'b1;
	#100	
	
	if(bl1 == 1'b1) $display("Correct for 1\n");
	else begin
		$display("Incorrect for 1\n");
		$stop;
		end
		
	if(bl2 == 1'b1) $display("Correct for 2\n");
	else begin
		$display("Incorrect for 2\n");
		$stop;
		end
		
	// input new value, enable write, then check read value	
	d = 1'b0;
	#100
	wen = 1'b1;
	#100
	
	if(bl1 == 1'b0) $display("Correct for 3\n");
	else begin
		$display("Incorrect for 3\n");
		$stop;
		end
		
	if(bl2 == 1'b0) $display("Correct for 4\n");
	else begin
		$display("Incorrect for 4\n");
		$stop;
		end
		
	$display("Passed!!!\n");
	#10
	
	$stop;    // stops simulation		
end

endmodule
