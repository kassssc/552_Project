module cpu(
	input clk,
	input rst_n,
	output hlt,
	output [15:0] pc
);

// pc control inputs - condition
wire [2:0]C; 

// pc control inputs - Flag
wire [2:0]F;

// old pc
wire [15:0]PC_in;

// new pc after calculation
wire [15:0]PC_out;

// instruction fetched from Instruction-memory
wire [15:0]instruction;

// Mux output to Registers file
wire [3:0]write_reg;

// Data input to Registers file
wire [15:0]Read_data_1;
wire [15:0]Read_data_2;

// Data to be written to Registers
wire [15:0]Write_data;

// control for writing to reg 
wire RegWrite;

// current pc
wire [15:0]pc_current;

// signextend value for immediate 
wire [15:0]signextend;

// wire connect mux to alu 
wire [15:0]muxtoalu;

// wire connect alu to data memory
wire [15:0]ALU_out;

// data memory output to select mux
wire [15:0]Data_memory_out;

// pcs instruction only
// sum of current pc + 2
wire [15:0]pcs_sum;

// control signal for writing to memory
wire MemWrite;

// control signal for immediate or reg 
// no need to use this???
// wire RegDst;

// control signal for using immediate or reg
wire ALUsrc;

// control signal for assert writing from mem to reg
wire MemtoReg;

// hlt internal connect signal, assert when hlt is called
wire hlt_internal;

// pcs internal signal, assert when pcs is called
wire pcs;

// decide if this is a ALU operation
wire ALUOp;

// decide if this is LHB or LLB
wire tophalf;

// wire for flag
wire f_internal;

//flag write from alu
wire [2:0]flag_write;

// make the output = current pc
assign pc = pc_current;
assign hlt = hlt_internal;


// instantiate pc register
PC_Register pc_reg(
	.PC_new(PC_out),
	.clk(clk),
	.rst(rst_n),
	.PC_current(pc_current)
);


// instantiate pc control unit
PC_control PC_control(
	.C(C),
	.I(instruction[8:0]), 
	.F(F), 
	.hlt(hlt_internal),
	.PC_in(PC_in),
	.PC_out(pc_out)
);


// instantiate instruction mem
memory1c instrucion_mem(
	.data_out(instruction), 
	.data_in({15{1'b0}}), 
	.addr(pc_current), 
	.enable(1'b1), 
	.wr(1'b0), 
	.clk(clk), 
	.rst(rst_n)
);

// instantiate control unit
Control_Unit  control_unit(
	.instruction(instruction[15:12]),
	//.RegDst(RegDst),
	.MemRead(MemRead), 
	.MemtoReg(MemtoReg), 
	.MemWrite(MemWrite),
	.ALUSrc(ALUSrc),
	.RegWrite(RegWrite),
	.hlt(hlt_internal),
	.pcs(pcs)
);

// make write register always the first reg in instruction 
assign write_reg = instruction[11:8];


// instantiate RegisterFile
RegisterFile RegisterFile(
	.clk(clk), 
	.rst(rst_n), 
	.SrcReg1(instruction[7:4]), 
	.SrcReg2(instruction[3:0]), 
	.DstReg(instruction[11:8]), 
	.WriteReg(RegWrite), 
	.DstData(Write_data), 
	.SrcData1(Read_data_1), 
	.SrcData2(Read_data_2)
);

// sign extended immediate
assign signextend = {{12{instruction[8]}}, instruction[3:0]};

// is the last 4bit reg or immediate
assign muxtoalu = (ALUsrc) ? signextend: Read_data_2;

// instantiate ALU
ALU alu(
	.ALU_in1(Read_data_1), 
	.ALU_in2(muxtoalu), 
	.op(instruction[14:12]), 
	.ALU_out(ALU_out), 
	.flag(f_internal),
	.flag_write(flag_write)
);

// instantiate flag_reg
flag_register flag_reg(
	.flag_new(f_internal),
	.wen(flag_write),
	.clk(clk),
	.rst(rst_n),
	.flag_current(F)
);


// instantiate data memory
memory1c Data_memory(
	.data_out(Data_memory_out), 
	.data_in(Read_data_2), 
	.addr(ALU_out), 
	.enable(1'b1), 
	.wr(MemWrite), 
	.clk(clk), 
	.rst(rst_n)
);

// instantiate 16 bit adder for pcs instruction 
full_adder_16bit pcs_adder (
	.A(pc_current), 
	.B(2), 
	.Cin(1'b0), 
	.Sum(pcs_sum), 
	.Cout()
);

// logic for decide which data to write
assign Write_data = (pcs)? pcs_sum : 
					(MemtoReg)? Data_memory_out:
					(ALUOp)? ALU_out:
					(tophalf) ? (ALU_out | instruction[7:0]):
					(ALU_out | (instruction[7:0] << 8));
					

endmodule




