module Register_tb();

logic clk,rst;
logic [15:0] D;
logic WriteReg, ReadEnable1, ReadEnable2;
wire [15:0] Bitline1, Bitline2;

Register DUT( 
	.clk(clk),
	.rst(rst), 
	.D(D), 
	.WriteReg(WriteReg), 
	.ReadEnable1(ReadEnable1), 
	.ReadEnable2(ReadEnable2), 
	.Bitline1(Bitline1), 
	.Bitline2(Bitline2)
);

always #5 clk = ~clk;

initial begin
	clk = 1'b0;
	rst = 1'b1;
	#20

	rst = 1'b0;
	#20
	
	assign D = 16'hffff;
	#100
	
	assign WriteReg = 1'b1;
	#100 
	
	assign ReadEnable1 = 1'b1;
	#100
	
	assert(Bitline1 == 16'hffff) $display("success");
		else $display("wrong : %h", Bitline1);
	#100
	
	assign ReadEnable2 = 1'b1;
	#100
	assert(Bitline2 == 16'hffff) $display("success");
		else $display("wrong : %h", Bitline2);
	
end

endmodule

