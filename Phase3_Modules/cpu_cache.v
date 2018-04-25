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

// I-mem signals
wire [15:0] I_mem_data_out;
wire [15:0] I_mem_read_addr;
wire 		I_mem_datavalid;

// I_cache
wire [15:0] cache_data_out_I; // data read from the cache

wire 		MemRead_I; // does cache want any data from mem?
wire [15:0] mem_read_addr_I; // addr cache wants to read from mem when transferring data
wire 		MemWrite_I; // Does the cache want to write to mem?
wire 		stall_I; // 
wire 		cachehit_I;

// D-mem signals
wire [15:0] D_mem_data_out;
wire [15:0] D_mem_data_in;
wire [15:0] D_mem_read_addr;
wire 		D_mem_datavalid, D_MemRead, D_MemWrite;

// D_cache
wire 		pipe_MemRead_D; // does the pipeline want to read something from mem?
wire [15:0] pipe_read_addr_D; // PC for I-cache, mem_read_addr for D-cache
wire 		pipe_MemWrite_D; // always 0 for I-cache
wire [15:0] pipe_mem_write_addr_D; // mem addr the pipeline wants to write to
wire [15:0] pipe_mem_write_data_D; // data the pipeline wants to write to mem

wire [15:0] cache_data_out_D; // data read from the cache

wire 		MemDataValid_D;	// is data from memory valid?
wire [15:0] mem_read_data_D; // data read from memory

wire 		MemRead_D; // does cache want any data from mem?
wire [15:0] mem_read_addr_D; // addr cache wants to read from mem when transferring data
wire 		MemWrite_D; // Does the cache want to write to mem?
wire 		stall_D;
wire  		cachehit_D;
wire [1:0]S_out;
wire stall_hazard;

//------------------------------------------------------------------------------
// I-MEM and  I-CACHE
//------------------------------------------------------------------------------
wire [15:0] pc_current, pc_plus_2;

memory4c I_MEM(
	.data_out(I_mem_data_out[15:0]), 
	.data_in(16'h0000), 
	.addr(I_mem_read_addr[15:0]), 
	.enable(MemRead_I), 
	.wr(1'b0), 
	.clk(clk), 
	.rst(rst), 
	.data_valid(I_mem_datavalid)
);
CACHE cache_I(
	.clk(clk),
	.rst(rst),

	// PIPELINE Interface
	.pipe_MemRead(1'b1), // does the pipeline want to read something from mem?
	.pipe_read_addr(pc_current[15:0]), // PC for I-cache, mem_read_addr for D-cache
	.pipe_MemWrite(1'b0), // always 0 for I-cache
	.pipe_mem_write_addr(16'b0), // mem addr the pipeline wants to write to
	.pipe_mem_write_data(16'b0), // data the pipeline wants to write to mem

	.cache_data_out(IF_instr[15:0]), // data read from the cache

	// MEMORY MODULE INTERFACE
	// Interfaces with memory
	// These come from pipeline registers MEM stage
	.MemDataValid(I_mem_datavalid),	// is data from memory valid?
	.mem_read_data(I_mem_data_out[15:0]), // data read from memory

	.cache_MemRead(MemRead_I), // does cache want any data from mem?
	.cache_mem_read_addr(I_mem_read_addr[15:0]), // addr cache wants to read from mem when transferring data
	.cache_MemWrite(), // Does the cache want to write to mem?
	.stall(stall_I), // Stall pipeline while cache is busy transferring data from mem
	.cachehit(cachehit_I)
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

CLA_16b pc_adder (
	.A(pc_current[15:0]),
	.B(16'h0002),
	.sub(1'b0),
	.S(pc_plus_2[15:0]),
	.ovfl(),
	.neg()
);
/* Deprecated
memory1c instr_mem (
	.data_out(IF_instr[15:0]),
	.data_in({16{1'b0}}),
	.addr(pc_current[15:0]),
	.enable(1'b1),
	.wr(1'b0),
	.clk(clk),
	.rst(rst)
);
*/
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
wire [15:0] mem_read_out, mem_write_data;

assign MEM_reg_write_data = MEM_MemToReg? mem_read_out[15:0] : MEM_EX_reg_write_data[15:0];
assign mem_write_data[15:0] = MEM_ALU_in_1[15:0];
assign mem_read_out = cache_data_out_D;

CACHE D_CACHE(
	.clk(clk),
	.rst(rst),

	// PIPELINE Interface
	.pipe_MemRead(MEM_MemToReg), // does the pipeline want to read something from mem?
	.pipe_read_addr(MEM_mem_addr[15:0]), // PC for I-cache, mem_read_addr for D-cache
	.pipe_MemWrite(MEM_MemWrite), // always 0 for I-cache
	.pipe_mem_write_addr(MEM_mem_addr[15:0]), // mem addr the pipeline wants to write to
	.pipe_mem_write_data(mem_write_data[15:0]), // data the pipeline wants to write to mem

	.cache_data_out(cache_data_out_D), // data read from the cache

	// MEMORY MODULE INTERFACE
	// Interfaces with memory
	// These come from pipeline registers MEM stage
	.MemDataValid(MemDataValid_D),	// is data from memory valid?
	.mem_read_data(mem_read_data_D[15:0]), // data read from memory

	.cache_MemRead(MemRead_D), // does cache want any data from mem?
	.cache_MemWrite(MemWrite_D), // Does the cache want to write to mem?
	.cache_mem_read_addr(mem_read_addr_D[15:0]), // addr cache wants to read from mem when transferring data
	.stall(stall_D), // Stall pipeline while cache is busy transferring data from mem
	.cachehit(cachehit_D)
);

memory4c D_MEM(
	.data_out(mem_read_data_D[15:0]), 
	.data_in(mem_write_data[15:0]), 
	.addr(mem_read_addr_D[15:0]), 
	.enable(MemRead_D | MemWrite_D), 
	.wr(MemWrite_D), 
	.clk(clk), 
	.rst(rst), 
	.data_valid(MemDataValid_D)
);

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
assign stall = stall_I | stall_D | stall_hazard;

endmodule