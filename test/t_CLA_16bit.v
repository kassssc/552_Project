module t_CLA_16b;

reg[15:0] stimA, stimB; 
reg sub;

wire[15:0] Sum; 
wire[2:0] flag;

CLA_16b UUT (.A(stimA), .B(stimB), .sub(sub), .S(Sum), .flag(flag));

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





endmodule // t_CLA_16b