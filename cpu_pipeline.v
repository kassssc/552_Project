module cpu(
	input clk,
	input rst_n,
	output hlt,
	output [15:0] pc
);

wire rst;
assign rst = ~rst_n;

//------------------------------------------------------------------------------
// IF: INSTRUCTION FETCH STAGE
//------------------------------------------------------------------------------
wire [15:0] IF_pc_curr;
wire [15:0] IF_pc_new;
wire [15:0] IF_pc_plus_4;
wire [15:0] IF_instr;

// branch signal from ID stage
assign IF_pc_new = branch? IF_pc_branch : IF_pc_plus_4;

PC_REG pc_reg (
	.pc_new(IF_pc_new[15:0]),
	.clk(clk),
	.rst(rst),
	.pc_current(IF_pc_current[15:0])
);
CLA_16b pc_adder (
	.A(IF_pc_current[15:0]),
	.B(16'h0004),
	.sub(1'b0),
	.S(IF_pc_plus_4[15:0]),
	.ovfl(),
	.neg()
);
memory1c instr_mem (
	.data_out(IF_instr[15:0]),
	.data_in({16{1'b0}}),
	.addr(IF_pc_current[15:0]),
	.enable(1'b1),
	.wr(1'b0),
	.clk(clk),
	.rst(rst)
);

//------------------------------------------------------------------------------
// IF-ID State Reg
//------------------------------------------------------------------------------
wire [15:0] ID_pc_curr;
wire [15:0] ID_instr;
IF_ID IFID(
	.pc_plus_4_new(IF_pc_plus_4[15:0]),
	.instr_new(IF_instr[15:0]),
	.clk(clk),
	.rst(flush),
	.wen(~stall),
	.pc_plus_4_curr(ID_pc_curr[15:0]),
	.instr_curr(ID_instr_curr[15:0])
);

//------------------------------------------------------------------------------
// ID: INSTRUCTION DECODE STAGE
//------------------------------------------------------------------------------

//current flag
wire [2:0] flag_current;
// wire for flag
wire [2:0] flag_new;
//flag write from alu
wire [2:0] flag_write_enable;

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

//
// Interpret Instruction Bits
//
wire ALU_opcode[2:0];
assign ALU_opcode = instruction[14:12];

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

Control_Unit control_unit(
	.instruction(instruction[15:12]),
	//.RegDst(RegDst),
	.MemRead(MemRead),
	.MemtoReg(WriteMemToReg),
	.MemWrite(MemWrite),
	.ALUSrc(ALU_src_imm),
	.RegWrite(RegWrite),
	.hlt(hlt_internal),
	.pcs(pcs),
	.ALUOp(ALUOp),
	.tophalf(TopHalf)
);
FLAG_REG flag_reg(
	.flag_new(flag_new[2:0]),
	.wen(flag_write_enable[2:0]),
	.clk(clk),
	.rst(rst),
	.flag_current(flag_current[2:0])
);
RegisterFile register_file(
	.clk(clk),
	.rst(rst),
	.SrcReg1(reg_read_select_1[3:0]),
	.SrcReg2(reg_read_select_2[3:0]),
	.DstReg(reg_write_select[3:0]),
	.WriteReg(RegWrite),
	.DstData(reg_write_data[15:0]),
	.SrcData1(reg_data_out_1[15:0]),
	.SrcData2(reg_data_out_2[15:0])
);

//------------------------------------------------------------------------------
// EX: EXECUTION STAGE
//------------------------------------------------------------------------------

// ALU output
wire [15:0]ALU_out;
// wire connect mux to alu
wire [15:0]ALU_src_2;
// control signal for using immediate or reg
wire ALU_src_imm;
// MUX select ALU source 2
assign ALU_src_2 = (ALU_src_imm)? imm_signextend[15:0] : reg_data_out_2[15:0];

ALU alu (
	.ALU_in1(reg_data_out_1[15:0]),
	.ALU_in2(ALU_src_2[15:0]),
	.op(ALU_opcode[2:0]),
	.ALU_out(ALU_out[15:0]),
	.flag(flag_current[2:0]),
	.flag_write(flag_write_enable[2:0])
);


//------------------------------------------------------------------------------
// MEM: MEMORY STAGE
//------------------------------------------------------------------------------
memory1c data_mem(
	.data_out(mem_data_out),
	.data_in(reg_data_out_2),
	.addr(mem_write_addr),
	.enable(MemEnable),
	.wr(MemWrite),
	.clk(clk),
	.rst(rst)
);

//------------------------------------------------------------------------------
// WB: WRITEBACK STAGE
//------------------------------------------------------------------------------
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





assign MemEnable = MemRead | MemWrite;




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




