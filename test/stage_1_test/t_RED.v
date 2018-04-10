module t_RED;

reg[15:0] stimA, stimB; 
wire[15:0] dest; 
reg[1:0] x,y,z;
wire[1:0] s,cout;
reg[3:0] x2,y2,z2;
wire[3:0] s2,cout2;

RED_16b UUT0(.SrcData1(stimA), .SrcData2(stimB), .DesData(dest));
CSA_2b UUT1(.x(x), .y(y), .z(z), .s(s), .cout(cout));
CSA_4b UUT2(.x(x2), .y(y2), .z(z2), .s(s2), .cout(cout2));

// stimulus generation
initial begin
	x = 2'b0;
	y = 2'b0;
	z = 2'b0;
	#50

	x2 = 4'b0;
	y2 = 4'b0;
	z2 = 4'b0;
	#50

	stimA = 16'b0;
	stimB = 16'b0;
	#50 
	
	x = 2'h2;
	y = 2'b1;
	z = 2'b0;
	#50
	$display("CSA_2b:\nSum:%b\nCarry:%b\n",s,cout);
	// should be sum=0x3 carry=0

	x2 = 4'b0;
	y2 = 4'b0110;
	z2 = 4'b1;
	#50
	$display("CSA_4b:\nSum:%b\nCarry:%b\n",s2,cout2);
	// should be sum=0x7 carry=0

	stimA = 16'hffff;
	stimB = 16'hffff;
	#50 
	$display("A:%b\nB:%b\nResult:%h\n",stimA,stimB,dest);
	// result should be 0xfff8

	stimA = 16'h1234;
	stimB = 16'h5678;
	#50 
	$display("A:%b\nB:%b\nResult:%h\n",stimA,stimB,dest);
	// result should be 0x0024

	stimA = 16'h4545;
	stimB = 16'h1881;
	#50 
	$display("A:%b\nB:%b\nResult:%h\n",stimA,stimB,dest);
	// result should be 0x0024

	stimA = 16'h2864;
	stimB = 16'h1907;
	#50 
	$display("A:%b\nB:%b\nResult:%h\n",stimA,stimB,dest);
	// result should be 0x0025

	stimA = 16'h2de4;
	stimB = 16'hacf7;
	#50 
	$display("A:%b\nB:%b\nResult:%h\n",stimA,stimB,dest);
	// result should be 0xffcd

	
	#10
	
	$stop;    // stops simulation
end


endmodule