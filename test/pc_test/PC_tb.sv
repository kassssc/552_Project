module pc_tb();

logic hlt;
logic [2:0]	C;	// Condition Encoding
logic [2:0]	F;	// [ N V Z ]
logic [8:0]	I;
logic [15:0]	PC_current;
logic [15:0]	PC_out;


// instantiate pc register
PC_Register pc_reg(
	.PC_new(PC_out),
	.clk(clk),
	.rst(rst),
	.PC_current(pc_current)
);


// instantiate pc control unit
PC_control PC_control(
	.C(instruction[11:9]),
	.I(instruction[8:0]), 
	.F(F), 
	.hlt(hlt_internal),
	.PC_in(PC_current),
	.PC_out(PC_out)
);

