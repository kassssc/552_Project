module RegisterFile_tb();

logic clk;
logic rst; 
logic [3:0] SrcReg1; 
logic [3:0] SrcReg2; 
logic [3:0] DstReg; 
logic WriteReg; 
logic [15:0] DstData; 
wire [15:0] SrcData1; 
wire [15:0] SrcData2;

RegisterFile DUT(
	.clk(clk), 
	.rst(rst), 
	.SrcReg1(SrcReg1), 
	.SrcReg2(SrcReg2), 
	.DstReg(DstReg), 
	.WriteReg(WriteReg), 
	.DstData(DstData), 
	.SrcData1(SrcData1), 
	.SrcData2(SrcData2)
);

always #5 clk = ~clk;

initial begin
	clk = 1'b0;
	rst = 1'b1;
	#100

	//rst = 1'b0;
	#100
	
	assign WriteReg = 1'b1;
	#100 
	
	assign DstReg = 4'b0000;
	#100
	
	assign DstData = 16'h1111;
	#100
	
	assign SrcReg1 = 4'b0000;
	#100
	
	assert(SrcData1 == 16'h1111) $display("success");
		else $display("wrong : %h", DstData);
	#100
	
	assign DstData = 16'hffff;
	#100
	
	assign SrcReg2 = 4'b1111;
	#100
	
	assert(SrcData2 == 16'hffff) $display("success");
		else $display("wrong : %h", DstData);
	
end

endmodule