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
wire [15:0] IF_pc_plus_2;
wire [15:0] IF_instr;

// branch signal from ID stage
assign IF_pc_new = EX_Branch? EX_pc_branch_target : IF_pc_plus_2;

PC_REG pc_reg (
	.pc_new(IF_pc_new[15:0]),
	.clk(clk),
	.rst(rst),
	.pc_current(IF_pc_current[15:0])
);
CLA_16b pc_adder (
	.A(IF_pc_current[15:0]),
	.B(16'h0002),
	.sub(1'b0),
	.S(IF_pc_plus_2[15:0]),
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
wire [15:0] ID_pc_plus_2;
wire [15:0] ID_instr;

IF_ID IFID(
	.pc_plus_2_new(IF_pc_plus_2[15:0]),
	.instr_new(IF_instr[15:0]),
	.clk(clk),
	.rst(FLUSH),
	.wen(~STALL),
	.pc_plus_2_curr(ID_pc_plus_2[15:0]),
	.instr_curr(ID_instr[15:0])
);

//------------------------------------------------------------------------------
// ID: INSTRUCTION DECODE STAGE
//------------------------------------------------------------------------------

// Reg select signals, decoded to 1-hot
wire [3:0] reg_read_select_1;
wire [3:0] reg_read_select_2;
// Register to write to, decoded to 1-hot
wire [3:0] reg_write_select;

// Data output from Registers file
wire [15:0] ID_reg_data_1;
wire [15:0] ID_reg_data_2;
// Data to be written to Registers
wire [15:0] reg_write_data; // COMES LATER STAGES
// control for writing to reg

wire ID_MemRead;
wire ID_MemWrite;
wire ID_MemToReg;
wire ID_RegWrite;
wire ID_BranchReg;

wire RegToMem;
assign RegToMem = ID_instr[15] & ~ID_instr[14] & ~ID_instr[13] & ID_instr[12];

// imm_signextend value for immediate
wire [15:0] ID_imm_signextend;
wire [8:0] ID_imm_branch;
assign ID_imm_signextend = {{12{ID_instr[3]}}, ID_instr[3:0]};
assign ID_imm_branch = ID_instr[8:0];

//
// Interpret Instruction Bits
//
wire ID_ALU_opcode[2:0];
assign ID_ALU_opcode = ID_instr[14:12];

// make write register always the first reg in instruction
assign ID_reg_write_select = ID_instr[11:8];
assign reg_read_select_1 = RegToMem? ID_instr[11:8] : ID_instr[7:4];
assign reg_read_select_2 = BranchReg? ID_instr[7:4] : ID_instr[3:0];

CTRL_UNIT control_unit (
	.instr(ID_instr[15:12]),
	.MemRead(ID_MemRead),
	.MemWrite(ID_MemWrite),
	.MemToReg(ID_MemToReg),
	.RegWrite(ID_RegWrite),
	.ALUimm(ID_ALUimm)
);

RegisterFile register_file (
	.clk(clk),
	.rst(rst),
	.SrcReg1(reg_read_select_1[3:0]),
	.SrcReg2(reg_read_select_2[3:0]),
	.DstReg(WB_reg_write_select[3:0]),
	.WriteReg(WB_RegWrite),
	.DstData(WB_reg_write_data[15:0]),
	.SrcData1(ID_reg_data_1[15:0]),
	.SrcData2(ID_reg_data_2[15:0])
);

//------------------------------------------------------------------------------
// ID_EX State Reg
//------------------------------------------------------------------------------
wire [15:0] EX_reg_data_1;
wire [15:0] EX_reg_data_2;
wire [15:0] EX_imm_signextend;

wire [2:0] EX_branch_cond;
wire EX_BranchImm, EX_BranchReg;

wire EX_ALU_opcode[2:0];
wire EX_ALU_src_imm;
wire EX_instr[15:0];

ID_EX IDEX (

);
//------------------------------------------------------------------------------
// EX: EXECUTION STAGE
//------------------------------------------------------------------------------

wire [2:0] flag_curr;
wire [2:0] flag_new;
wire [2:0] flag_write_enable;
wire [15:0] ALU_src_2;
wire [15:0] EX_lhb_out;
wire [15:0] EX_llb_out;

wire [15:0] ALU_out;

// Branch information, sent to IF stage
wire EX_Branch;
wire [15:0] EX_pc_branch_target;

wire [15:0] EX_reg_write_data;

assign lhb_out = {EX_instr[7:0], EX_reg_data_1[7:0]};
assign llb_out = {EX_reg_data_1[15:8], EX_instr[7:0]};


assign EX_reg_write_data = (ALUop)? ALU_out[15:0] :
						   (lhb)? lhb_out[15:0] :
						   (llb)? llb_out[15:0] :
						   EX_pc_plus_2[15:0];

// MUX select ALU source 2
assign ALU_src_2 = (EX_ALUimm)? EX_imm_signextend[15:0] : EX_reg_data_2[15:0];

ALU alu (
	.ALU_in1(EX_reg_data_1[15:0]),
	.ALU_in2(ALU_src_2[15:0]),
	.op(EX_instr[14:12]),
	.ALU_out(ALU_out[15:0]),
	.flag(flag_current[2:0]),
	.flag_write(flag_write_enable[2:0])
);
FLAG_REG flag_reg(
	.flag_new(flag_new[2:0]),
	.wen(flag_write_enable[2:0]),
	.clk(clk),
	.rst(rst),
	.flag_current(flag_curr[2:0])
);
BRANCH_CTRL branch_control (
	.pc_plus_2(EX_pc_plus_2[15:0]),
	.BranchImm(EX_BranchImm),
	.BranchReg(EX_BranchReg),
	.imm(EX_instr[8:0]),
	.cc(EX_instr[11:9]),
	.flag(flag_curr[2:0])
	.branch_reg_data(EX_reg_data_2[15:0]),
	.Branch(EX_Branch),
	.pc_out(EX_pc_branch_target[15:0])
);

//------------------------------------------------------------------------------
// MEM: MEMORY STAGE
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

assign MemEnable = MemRead | MemWrite;

CLA_16b mem_addr_adder (
	.A(reg_data_out_1),
	.B({{12{instruction[3]}},instruction[3:0]}),
	.sub(1'b0)
	.Sum(mem_addr),
	.ovfl(),
	.neg()
);
memory1c data_mem(
	.data_out(mem_data_out),
	.data_in(reg_data_out_2),
	.addr(mem_addr),
	.enable(MemEnable),
	.wr(MemWrite),
	.clk(clk),
	.rst(rst)
);

//------------------------------------------------------------------------------
// WB: WRITEBACK STAGE
//------------------------------------------------------------------------------


// logic for decide which data to write
assign WB_reg_write_data = MemToReg? MEM_mem_data[15:0] :
						   MEM_EX_reg_write_data[15:0];



// hlt internal connect signal, assert when hlt is called
wire hlt_internal;

// decide if this is a ALU operation
wire ALUOp;

// decide if this is LHB or LLB
wire TopHalf;

// make the output = current pc
assign pc = pc_current;
assign hlt = hlt_internal;

endmodule




