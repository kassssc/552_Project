module cpu(
	input clk,
	input rst_n,
	output hlt,
	output [15:0] pc
);

wire rst;
assign rst = ~rst_n;
// pc control inputs - Flag
wire [2:0]F;

// new pc after calculation
wire [15:0]PC_out;

// instruction fetched from Instruction-memory
wire [15:0]instruction;

// Register to write to, decoded to 1-hot
wire [3:0]write_reg;

// Data output from Registers file
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

// ALU output
wire [15:0]ALU_out;

// data memory output to select mux
wire [15:0]Data_memory_out;

// pcs instruction only
// sum of current pc + 2
wire [15:0]pcs_sum;

// control singal for red from memory1c
wire MemRead;

// control signal for writing to memory
wire MemWrite;

// control signal for immediate or reg 
// no need to use this???
// wire RegDst;

// control signal for using immediate or reg
wire ALUsrc;

// control signal for assert writing from mem to reg
wire MemtoReg;

// datamemory enable
wire memory_enable;

// hlt internal connect signal, assert when hlt is called
wire hlt_internal;

// pcs internal signal, assert when pcs is called
wire pcs;

// decide if this is a ALU operation
wire ALUOp;

// decide if this is LHB or LLB
wire tophalf;

// wire for flag
wire [2:0] f_internal;

//flag write from alu
wire [2:0]flag_write;

// Addr for memory write
wire [15:0] mem_addr;

wire [3:0] bit_select1;
wire [3:0] bit_select2;


// make the output = current pc
assign pc = pc_current;
assign hlt = hlt_internal;


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
	.PC_in(pc_current),
	.PC_out(PC_out),
	.B(instruction[15:12]),
	.branch_reg_in(Read_data_2)
);


// instantiate instruction mem
memory1c instrucion_mem(
	.data_out(instruction), 
	.data_in({16{1'b0}}), 
	.addr(pc_current), 
	.enable(1'b1), 
	.wr(1'b0), 
	.clk(clk), 
	.rst(rst)
);

// instantiate control unit
Control_Unit  control_unit(
	.instruction(instruction[15:12]),
	//.RegDst(RegDst),
	.MemRead(MemRead), 
	.MemtoReg(MemtoReg), 
	.MemWrite(MemWrite),
	.ALUSrc(ALUsrc),
	.RegWrite(RegWrite),
	.hlt(hlt_internal),
	.pcs(pcs),
	.ALUOp(ALUOp),
	.tophalf(tophalf)
);

// make write register always the first reg in instruction 
assign write_reg = instruction[11:8];
assign bit_select1 = (pcs | MemtoReg | ALUOp)? instruction[7:4]:instruction[11:8];
assign bit_select2 = (instruction[15] & instruction[14] & ~instruction[13] & instruction[12])? instruction[7:4] : instruction[3:0];


// instantiate RegisterFile
RegisterFile RegisterFile(
	.clk(clk), 
	.rst(rst), 
	.SrcReg1(bit_select1), 
	.SrcReg2(bit_select2), 
	.DstReg(write_reg), 
	.WriteReg(RegWrite), 
	.DstData(Write_data), 
	.SrcData1(Read_data_1), 
	.SrcData2(Read_data_2)
);

// sign extended immediate
assign signextend = {{12{instruction[3]}}, instruction[3:0]};

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
	.rst(rst),
	.flag_current(F)
);

assign memory_enable = MemRead|MemWrite;

// instantiate data memory
memory1c Data_memory(
	.data_out(Data_memory_out), 
	.data_in(Read_data_2), 
	.addr(mem_addr), 
	.enable(memory_enable), 
	.wr(MemWrite), 
	.clk(clk), 
	.rst(rst)
);

full_adder_16b mem_addr_adder (
	.A(Read_data_1), 
	.B({{12{instruction[3]}},instruction[3:0]}),
	.cin(1'b0), 
	.Sum(mem_addr), 
	.cout()
);

// instantiate 16 bit adder for pcs instruction 
full_adder_16b pcs_adder (
	.A(pc_current), 
	.B(16'h0002), 
	.cin(1'b0), 
	.Sum(pcs_sum), 
	.cout()
);

// logic for decide which data to write
assign Write_data = (pcs)? pcs_sum : 
					(MemtoReg)? Data_memory_out:
					(ALUOp)? ALU_out:
					(tophalf)? ({instruction[7:0], Read_data_1[7:0]}):
					({Read_data_1[15:8], instruction[7:0]});
					

endmodule




