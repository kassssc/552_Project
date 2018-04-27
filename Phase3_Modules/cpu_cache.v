module cpu(
	input clk,
	input rst_n,
	output hlt,
	output [15:0] pc_out
);

//
// GLOBAL SIGNALS
//
wire rst, stall, flush;
wire [1:0] fwd_alu_A, fwd_alu_B;

// IF signals passed to ID
wire [15:0] IF_pc_new, IF_instr;

// ID signals received from IF
wire [15:0] ID_pc, ID_instr;
// ID signals passed to EX
wire [15:0] ID_reg_data_1, ID_reg_data_2;
wire [3:0] ID_reg_write_select;
wire ID_MemWrite, ID_MemToReg, ID_RegWrite;

// also: ID_instr

// EX signals received from ID
wire EX_ALUimm;
wire [15:0] EX_pc, EX_instr;
wire [15:0] EX_ALU_src_2;
// EX signals passed to MEM
wire [15:0] EX_reg_write_data;
wire [3:0] EX_reg_write_select;
wire [15:0] EX_mem_addr;
wire [15:0] EX_ALU_in_1, EX_ALU_in_2;
wire EX_RegWrite, EX_MemToReg, EX_MemWrite;
// EX signals used by IF
wire EX_Branch_new, EX_Branch_current;
wire [15:0] EX_pc_branch_target;

wire [15:0] EX_reg_data_1, EX_reg_data_2;

// MEM signals received from EX
wire MEM_MemToReg, MEM_MemWrite;
wire [15:0] MEM_mem_addr, MEM_ALU_in_1;
// MEM signals passed to WB
wire MEM_RegWrite;
wire [15:0] MEM_reg_write_data;
wire [3:0] MEM_reg_write_select;

// WB signals received from MEM & used by ID
wire WB_RegWrite;
wire [15:0] WB_reg_write_data;
wire [3:0] WB_reg_write_select;

wire [1:0]S_out;
wire stall_hazard;

//------------------------------------------------------------------------------
// MEM and CACHE
//------------------------------------------------------------------------------
wire MemRead, MemWrite, mem_DataValid;
wire[15:0] mem_data_out, mem_data_in, mem_read_addr, mem_write_data;

// cache busy means it "wants" to read from mem
// X_mem_fetch == 0 means cache X is stalled from getting data from mem (if it wants to)
// X_mem_fetch == 1 means cache X is allowed to grab data from memory

// I-CACHE
wire I_mem_fetch, I_CacheBusy, I_CacheFinish, I_MemRead, I_CacheHit;
wire [15:0] I_cache_mem_read_addr;

// D-CACHE
wire D_mem_fetch, D_MemWrite, D_CacheBusy, D_CacheFinish, D_MemRead, D_CacheHit;
wire [15:0] D_cache_mem_read_addr;

wire [15:0] cache_data_out; // data out of cache to whereever needs it

// Assign memory control signals
assign mem_read_addr = I_mem_fetch? I_cache_mem_read_addr[15:0] :
					   D_mem_fetch? D_cache_mem_read_addr[15:0] : 16'h0000;
assign MemRead = I_mem_fetch | D_mem_fetch;
assign MemWrite = D_MemWrite;

wire [15:0] pc_current, pc_plus_2;

memory4c MAIN_MEM(
	.clk(clk),
	.rst(rst),

	.data_in(mem_write_data[15:0]), // from MEM stage
	.addr(mem_read_addr[15:0]),
	.enable(MemRead | MemWrite),
	.wr(MemWrite),

	.data_out(mem_data_out[15:0]),
	.data_valid(mem_DataValid)
);

mem_control_fsm mem_ctrl (
	.clk(clk),
	.rst(rst),

	// Inputs
	.I_CacheBusy(I_MemRead),
	.D_CacheBusy(D_MemRead),
	.I_cache_finished(I_CacheFinish),
	.D_cache_finished(D_CacheFinish),

	// Mem ctrl signals
	.I_mem_fetch(I_mem_fetch),
	.D_mem_fetch(D_mem_fetch)
);

CACHE cache_I(
	.clk(clk),
	.rst(rst),

	// PIPELINE Interface
	.pipe_MemRead(1'b1),
	.pipe_read_addr(pc_current[15:0]), // I cache always want to read the PC
	.pipe_MemWrite(1'b0), // always 0 for I-cache
	.pipe_mem_write_addr(16'h0000), // mem addr the pipeline wants to write to
	.pipe_mem_write_data(16'b0000), // data the pipeline wants to write to mem

	.cache_data_out(IF_instr[15:0]), // INSTR

	// MEMORY MODULE INTERFACE
	.MemDataValid(I_mem_fetch & mem_DataValid),	// is data from memory valid?
	.mem_read_data(mem_data_out[15:0]), // data read from memory

	.cache_mem_addr(I_cache_mem_read_addr[15:0]), // addr cache wants to read from mem when transferring data
	.cache_MemRead(I_MemRead),
	.cache_MemWrite(), // Does the cache want to write to mem?

	.CacheHit(I_CacheHit),
	.CacheFinish(I_CacheFinish),
	.CacheBusy(I_CacheBusy) // Stall pipeline while cache is busy transferring data from mem
);
CACHE D_CACHE(
	.clk(clk),
	.rst(rst),

	// PIPELINE Interface
	.pipe_MemRead(MEM_MemToReg), // does the pipeline want to read something from mem?
	.pipe_read_addr(MEM_mem_addr[15:0]), // PC for I-cache, mem_read_addr for D-cache
	.pipe_MemWrite(MEM_MemWrite), //
	.pipe_mem_write_addr(MEM_mem_addr[15:0]), // mem addr the pipeline wants to write to
	.pipe_mem_write_data(mem_write_data[15:0]), // data the pipeline wants to write to mem

	.cache_data_out(cache_data_out[15:0]), // data read from the cache

	// MEMORY MODULE INTERFACE
	// These come from pipeline registers MEM stage
	.MemDataValid(D_mem_fetch & mem_DataValid),	// is data from memory valid?
	.mem_read_data(mem_data_out[15:0]), // data read from memory

	// CACHE memory control interface
	.cache_MemWrite(D_MemWrite), // Does the cache want to write to mem?
	.cache_MemRead(D_MemRead),
	.cache_mem_addr(D_cache_mem_read_addr[15:0]), // addr specified for read/write by cache

	.CacheHit(D_CacheHit),
	.CacheFinish(D_CacheFinish),
	.CacheBusy(D_CacheBusy) // Stall pipeline while cache is busy transferring data from mem
);

//------------------------------------------------------------------------------
// IF: INSTRUCTION FETCH STAGE
//------------------------------------------------------------------------------
// branch signal from ID stage
assign IF_pc_new = EX_Branch_current? EX_pc_branch_target : pc_plus_2;

state_reg pc_reg (
	.state_new(IF_pc_new[15:0]),
	.clk(clk),
	.rst(rst),
	.wen(~stall),
	.state_current(pc_current[15:0])
);

wire [15:0] pc_add;
assign pc_add = rst? 16'h0000: 16'h0002;

CLA_16b pc_adder (
	.A(pc_current[15:0]),
	.B(pc_add),
	.sub(1'b0),
	.S(pc_plus_2[15:0]),
	.ovfl(),
	.neg()
);

//------------------------------------------------------------------------------
// IF-ID State Reg
//------------------------------------------------------------------------------
IF_ID IFID(
	.pc_plus_2_new(IF_pc_new[15:0]),
	.instr_new(IF_instr[15:0]),
	.clk(clk),
	.rst(flush | rst),
	.wen(~stall),
	.pc_plus_2_current(ID_pc[15:0]),
	.instr_current(ID_instr[15:0])
);

//------------------------------------------------------------------------------
// ID: INSTRUCTION DECODE STAGE
//------------------------------------------------------------------------------
wire ID_lhb, ID_llb;
wire [3:0] ID_reg_read_select_1, ID_reg_read_select_2;

assign ID_lhb = (ID_instr[15:12] == 4'b1010);
assign ID_llb = (ID_instr[15:12] == 4'b1011);
assign RegToMem = (ID_instr[15:12] == 4'b1001); //SW

assign ID_reg_write_select = ID_instr[11:8];
assign ID_reg_read_select_1 = (RegToMem | ID_lhb | ID_llb)? ID_instr[11:8] : ID_instr[7:4];
assign ID_reg_read_select_2 = (RegToMem | ID_MemToReg)? ID_instr[7:4] : ID_instr[3:0];

CTRL_UNIT control_unit (
	.instr(ID_instr[15:12]),
	.flush(flush),
	.MemWrite(ID_MemWrite),
	.MemToReg(ID_MemToReg),
	.RegWrite(ID_RegWrite)
);

// TODO: REG BYPASSING
RegisterFile register_file (
	.clk(clk),
	.rst(rst),
	.SrcReg1(ID_reg_read_select_1[3:0]),
	.SrcReg2(ID_reg_read_select_2[3:0]),
	.DstReg(WB_reg_write_select[3:0]),
	.WriteReg(WB_RegWrite),
	.DstData(WB_reg_write_data[15:0]),
	.SrcData1(ID_reg_data_1[15:0]),
	.SrcData2(ID_reg_data_2[15:0])
);

//------------------------------------------------------------------------------
// ID_EX State Reg
//------------------------------------------------------------------------------
wire [3:0] EX_reg_read_select_1, EX_reg_read_select_2;
ID_EX IDEX (
	.pc_new(ID_pc[15:0]),
	.data1_new(ID_reg_data_1[15:0]),
	.data2_new(ID_reg_data_2[15:0]),
	.sel_reg_1_new(ID_reg_read_select_1[3:0]),
	.sel_reg_2_new(ID_reg_read_select_2[3:0]),
	.instr_new(ID_instr[15:0]),
	.regwrite_new(ID_RegWrite),
	.reg_write_select_new(ID_reg_write_select[3:0]),
	.memtoreg_new(ID_MemToReg),
	.memwrite_new(ID_MemWrite),
	.clk(clk),
	.rst(flush | rst),
	.wen(~stall),
	.pc_current(EX_pc[15:0]),
	.data1_current(EX_reg_data_1[15:0]),
	.data2_current(EX_reg_data_2[15:0]),
	.sel_reg_1_current(EX_reg_read_select_1[3:0]),
	.sel_reg_2_current(EX_reg_read_select_2[3:0]),
	.instr_current(EX_instr[15:0]),
	.regwrite_current(EX_RegWrite),
	.reg_write_select_current(EX_reg_write_select[3:0]),
	.memtoreg_current(EX_MemToReg),
	.memwrite_current(EX_MemWrite)
);

//------------------------------------------------------------------------------
// EX: EXECUTION STAGE
//------------------------------------------------------------------------------
wire EX_lhb, EX_llb, ALUop, SW, LW, BranchImm, BranchReg, ALUshift;

wire [2:0] flag_current, flag_new, flag_write_enable, flag_alu_out;
wire [15:0] lhb_out, llb_out, ALU_out;
wire [15:0] imm_signextend, mem_addr_offset;

assign ALUop = (EX_instr[15] == 1'b0);
assign BranchImm = (EX_instr[15:12] == 4'b1100);
assign BranchReg = (EX_instr[15:12] == 4'b1101);
assign EX_lhb = (EX_instr[15:12] == 4'b1010);
assign EX_llb = (EX_instr[15:12] == 4'b1011);
assign LW = (EX_instr[15:12] == 4'b1000); // MemToReg
assign SW = (EX_instr[15:12] == 4'b1001); // RegToMem
assign ALUshift = (
					(EX_instr[15:12] == 4'b0100) |
					(EX_instr[15:12] == 4'b0101) |
					(EX_instr[15:12] == 4'b0110)
				  );

assign mem_addr_offset = {{12{EX_instr[3]}}, EX_instr[3:0] << 1};

// Mem stage will choose between this and mem read output
assign EX_reg_write_data = (ALUop)? ALU_out[15:0] :		// ALUop
						   (EX_lhb)? lhb_out[15:0] :	// LHB
						   (EX_llb)? llb_out[15:0] :	// LLB
						   EX_pc[15:0];					// PCS

assign EX_ALU_src_2 = ALUshift? imm_signextend[15:0] : EX_reg_data_2[15:0];

//
// Handle Data Forwarding
//
assign EX_ALU_in_1 = (fwd_alu_A[1:0] == 2'b00)? EX_reg_data_1[15:0] :
				  (fwd_alu_A[1])? MEM_reg_write_data[15:0] :
				  WB_reg_write_data[15:0];
assign EX_ALU_in_2 = (fwd_alu_B[1:0] == 2'b00)? EX_ALU_src_2[15:0] :
					 (fwd_alu_B[1])? MEM_reg_write_data[15:0] :
					 WB_reg_write_data[15:0];

assign imm_signextend = {{12{EX_instr[3]}}, EX_instr[3:0]};


assign lhb_out = {EX_instr[7:0], EX_ALU_in_1[7:0]};
assign llb_out = {EX_ALU_in_1[15:8], EX_instr[7:0]};

assign flag_new = flush? 3'b000 : flag_alu_out[2:0];

ALU alu (
	.ALU_in1(EX_ALU_in_1[15:0]),
	.ALU_in2(EX_ALU_in_2[15:0]),
	.op(EX_instr[14:12]),
	.ALU_out(ALU_out[15:0]),
	.flag(flag_alu_out[2:0]),
	.flag_write(flag_write_enable[2:0])
);
FLAG_REG flag_reg(
	.flag_new(flag_new[2:0]),
	.wen(flag_write_enable[2:0]),
	.clk(clk),
	.rst(flush | rst),
	.flag_current(flag_current[2:0])
);
reg_1bit branch_cond_reg (
	.reg_new(EX_Branch_new),
	.reg_current(EX_Branch_current),
	.clk(clk),
	.rst(rst),
	.wen(1'b1)
);
BRANCH_CTRL branch_control (
	.pc_plus_2(EX_pc[15:0]),
	.BranchImm(BranchImm),
	.BranchReg(BranchReg),
	.imm(EX_instr[8:0]),
	.cc(EX_instr[11:9]),
	.flag(flag_current[2:0]),
	.branch_reg_data(EX_ALU_in_1[15:0]),
	.BranchOut(EX_Branch_new),
	.pc_out(EX_pc_branch_target[15:0])
);
CLA_16b mem_addr_adder (
	.A(EX_ALU_in_2[15:0] & 16'hFFFE),
	.B(mem_addr_offset[15:0]),
	.sub(1'b0),
	.S(EX_mem_addr[15:0]),
	.ovfl(),
	.neg()
);

//------------------------------------------------------------------------------
// EX_MEM State Reg
//------------------------------------------------------------------------------
wire [15:0] MEM_EX_reg_write_data;
EX_MEM EXMEM (
	.memtoreg_new(EX_MemToReg),
	.memwrite_new(EX_MemWrite),
	.reg_write_data_new(EX_reg_write_data[15:0]),
	.reg_write_select_new(EX_reg_write_select[3:0]),
	.regwrite_new(EX_RegWrite),
	.mem_addr_new(EX_mem_addr[15:0]),
	.alu_source_2_new(EX_ALU_in_1[15:0]),
	.clk(clk),
	.wen(1'b1),
	.rst(rst),
	.memtoreg_current(MEM_MemToReg),
	.memwrite_current(MEM_MemWrite),
	.reg_write_data_current(MEM_EX_reg_write_data[15:0]),
	.reg_write_select_current(MEM_reg_write_select[3:0]),
	.regwrite_current(MEM_RegWrite),
	.mem_addr_current(MEM_mem_addr[15:0]),
	.alu_source_2_current(MEM_ALU_in_1[15:0])
);

//------------------------------------------------------------------------------
// MEM: MEMORY STAGE
//------------------------------------------------------------------------------
wire MemEnable;

assign MEM_reg_write_data = MEM_MemToReg? cache_data_out[15:0] : MEM_EX_reg_write_data[15:0];
assign mem_write_data[15:0] = MEM_ALU_in_1[15:0];

//------------------------------------------------------------------------------
// MEM_WB State Reg
//------------------------------------------------------------------------------
MEM_WB MEMWB (
	.regwrite_new(MEM_RegWrite),
	.reg_write_data_new(MEM_reg_write_data[15:0]),
	.reg_write_select_new(MEM_reg_write_select[3:0]),
	.clk(clk),
	.wen(1'b1),
	.rst(rst),
	.regwrite_current(WB_RegWrite),
	.reg_write_data_current(WB_reg_write_data[15:0]),
	.reg_write_select_current(WB_reg_write_select[3:0])
);

//------------------------------------------------------------------------------
// WB: WRITEBACK STAGE
//------------------------------------------------------------------------------
hazard_detection hazards (
	.if_id_instr(ID_instr[15:0]),
	.id_ex_instr(EX_instr[15:0]),
	.id_ex_MemToReg(EX_MemToReg),
	.flush(flush),
	.clk(clk),
	.rst(rst),

	.stall(stall_hazard),
	.hlt_out(hlt)
);

forward forwarder (
	.ex_mem_regwrite(MEM_RegWrite),
	.mem_wb_regwrite(WB_RegWrite),
	.ex_mem_regdest(MEM_reg_write_select[3:0]),
	.mem_wb_regdest(WB_reg_write_select[3:0]),
	.id_ex_regrs(EX_reg_read_select_1[3:0]),
	.id_ex_regrt(EX_reg_read_select_2[3:0]),

	.forwardA(fwd_alu_A[1:0]),
	.forwardB(fwd_alu_B[1:0])
);

assign rst = ~rst_n;
assign flush = EX_Branch_current? 1'b1 : 1'b0;
assign pc_out = pc_current;
assign stall = I_CacheBusy | D_CacheBusy | stall_hazard;

endmodule