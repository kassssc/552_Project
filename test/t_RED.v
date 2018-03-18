module t_RED;

reg[15:0] stimA, stimB; 
wire[15:0] dest; 

RED_16b UUT(.SrcData1, .SrcData2, .DesData);

// stimulus generation
initial begin
	stimA = 16'b0;
	stimB = 16'b0;
	#50 
	$display("A:%b\nB:%b\nSum:%b\nFlag:%b\n",stimA,stimB,Sum,flag);
	// should show zero flag

	stimA = 16'h8001;
	stimB = 16'h8002;
	#50 
	$display("A:%b\nB:%b\nSum:%b\nFlag:%b\n",stimA,stimB,Sum,flag);
	// should show neg flag

	stimA = 16'h8000;
	stimB = 16'h8000;
	#50 
	$display("A:%b\nB:%b\nSum:%b\nFlag:%b\n",stimA,stimB,Sum,flag);
	// should show ovfl flag
	
	#10
	
	$stop;    // stops simulation
end

endmodule