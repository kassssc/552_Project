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
// wire for flag
wire [2:0]f_internal;
//flag write from alu
wire [2:0]flag_write;

// new pc after calculation
wire [15:0]PC_out;

// instruction fetched from Instruction-memory
wire [15:0]instruction;

// current pc
wire [15:0]pc_current;

// imm_signextend value for immediate
wire [15:0]imm_signextend;

// Reg select signals, decoded to 1-hot
wire [3:0]reg_read_select_1;
wire [3:0]reg_read_select_2;
// Register to write to, decoded to 1-hot
wire [3:0]reg_write_select;

// Data output from Registers file
wire [15:0]reg_data_out_1;
wire [15:0]reg_data_out_2;
// Data to be written to Registers
wire [15:0]reg_write_data;
// control for writing to reg
wire RegWrite;

// data memory output to select mux
wire [15:0]mem_data_out;
// Addr for memory write
wire [15:0]mem_write_addr;
// control singal for red from memory1c
wire MemRead;
// control signal for writing to memory
wire MemWrite;
// datamemory enable
wire MemEnable;
// control signal for assert writing from mem to reg
wire WriteMemToReg;

// ALU output
wire [15:0]ALU_out;
// wire connect mux to alu
wire [15:0]ALU_src_2;
// control signal for using immediate or reg
wire ALU_src_imm;

// hlt internal connect signal, assert when hlt is called
wire hlt_internal;

// pcs internal signal, assert when pcs is called
wire pcs;
// pcs instruction only
// sum of current pc + 2
wire [15:0]pcs_sum;

// decide if this is a ALU operation
wire ALUOp;

// decide if this is LHB or LLB
wire TopHalf;

// make the output = current pc
assign pc = pc_current;
assign hlt = hlt_internal;

// make write register always the first reg in instruction
assign reg_write_select = instruction[11:8];
assign reg_read_select_1 = (pcs | WriteMemToReg | ALUOp)? instruction[7:4] : instruction[11:8];
assign reg_read_select_2 = (instruction[15] & instruction[14] & ~instruction[13] & instruction[12])? instruction[7:4] : instruction[3:0];

// logic for decide which data to write
assign reg_write_data = (pcs)? pcs_sum :
						(WriteMemToReg)? mem_data_out:
						(ALUOp)? ALU_out:
						(TopHalf)? ({instruction[7:0], reg_data_out_1[7:0]}):
						({reg_data_out_1[15:8], instruction[7:0]});
// sign extended immediate
assign imm_signextend = {{12{instruction[3]}}, instruction[3:0]};

// is the last 4bit reg or immediate
assign ALU_src_2 = (ALU_src_imm)? imm_signextend : reg_data_out_2;

assign MemEnable = MemRead | MemWrite;

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
	.branch_reg_in(reg_data_out_2)
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
	.WriteMemToReg(WriteMemToReg),
	.MemWrite(MemWrite),
	.ALU_src_imm(ALU_src_imm),
	.RegWrite(RegWrite),
	.hlt(hlt_internal),
	.pcs(pcs),
	.ALUOp(ALUOp),
	.TopHalf(TopHalf)
);

// instantiate RegisterFile
RegisterFile RegisterFile(
	.clk(clk),
	.rst(rst),
	.SrcReg1(reg_read_select_1),
	.SrcReg2(reg_read_select_2),
	.DstReg(reg_write_select),
	.WriteReg(RegWrite),
	.DstData(reg_write_data),
	.SrcData1(reg_data_out_1),
	.SrcData2(reg_data_out_2)
);

// instantiate ALU
ALU alu(
	.ALU_in1(reg_data_out_1),
	.ALU_in2(ALU_src_2),
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

// instantiate data memory
memory1c Data_memory(
	.data_out(mem_data_out),
	.data_in(reg_data_out_2),
	.addr(mem_write_addr),
	.enable(MemEnable),
	.wr(MemWrite),
	.clk(clk),
	.rst(rst)
);

full_adder_16b mem_write_addr_adder (
	.A(reg_data_out_1),
	.B({{12{instruction[3]}},instruction[3:0]}),
	.cin(1'b0),
	.Sum(mem_write_addr),
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

endmodule




