module t_RED;

reg[15:0] stimA, stimB; 
wire[15:0] dest; 

RED_16b UUT(.SrcData1(stimA), .SrcData2(stimB), .DesData(dest));

// stimulus generation
initial begin
	stimA = 16'b0;
	stimB = 16'b0;
	#50 
	$display("A:%b\nB:%b\nResult:%b\n",stimA,stimB,dest);

	stimA = 16'hffff;
	stimB = 16'hffff;
	#50 
	$display("A:%b\nB:%b\nResult:%b\n",stimA,stimB,dest);
	// result should be 
	
	#10
	
	$stop;    // stops simulation
end

endmodule