module CTRL_UNIT(
	input  [3:0]instr,
	output reg MemRead,
	output reg MemWrite,
	output reg MemToReg,
	output reg RegWrite,
	output reg ALUop,
	output reg ALUimm,
	output reg pcs,
	output reg llb,
	output reg lhb,
	output reg hlt
);

localparam Asserted = 1'b1;
localparam Not_Asserted = 1'b0;

assign ALUop = ~instr[3];
assign BranchImm = instr[3] & instr[2] & ~instr[1] & ~instr[0];
assign BranchReg = instr[3] & instr[2] & ~instr[1] &  instr[0];
assign lhb = instr[3] & ~instr[2] & instr[1] & ~instr[0];
assign llb = instr[3] & ~instr[2] & instr[1] &  instr[0];
assign pcs = instr[3] &  instr[2] & instr[1] & ~instr[0];
assign hlt = instr[3] &  instr[2] & instr[1] &  instr[0];

always@(*) begin
	case(instr)
		// Add
		4'b0000: begin
			MemRead = Not_Asserted;
			MemWrite = Not_Asserted;
			MemToReg = Not_Asserted;
			RegWrite = Asserted;
			ALUimm = Not_Asserted;
		end

		// Sub
		4'b0001: begin
			MemRead = Not_Asserted;
			MemWrite = Not_Asserted;
			MemToReg = Not_Asserted;
			RegWrite = Asserted;
			ALUimm = Not_Asserted;
		end

		// Red
		4'b0010: begin
			MemRead = Not_Asserted;
			MemWrite = Not_Asserted;
			MemToReg = Not_Asserted;
			RegWrite = Asserted;
			ALUimm = Not_Asserted;
		end

		// XOR
		4'b0011: begin
			MemRead = Not_Asserted;
			MemWrite = Not_Asserted;
			MemToReg = Not_Asserted;

			RegWrite = Asserted;
			ALUimm = Not_Asserted;
		end

		// SLL
		4'b0100: begin
			MemRead = Not_Asserted;
			MemWrite = Not_Asserted;
			MemToReg = Not_Asserted;
			RegWrite = Asserted;
			ALUimm = Asserted;
		end

		// SRA
		4'b0101: begin
			MemRead = Not_Asserted;
			MemWrite = Not_Asserted;
			MemToReg = Not_Asserted;
			RegWrite = Asserted;
			ALUimm = Asserted;
		end

		// ROR
		4'b0110: begin
			MemRead = Not_Asserted;
			MemWrite = Not_Asserted;
			MemToReg = Not_Asserted;
			RegWrite = Asserted;
			ALUimm = Asserted;
		end

		// PADDSB
		4'b0111: begin
			MemRead = Not_Asserted;
			MemWrite = Not_Asserted;
			MemToReg = Not_Asserted;
			RegWrite = Asserted;
			ALUimm = Not_Asserted;
		end

		// LW
		4'b1000: begin
			MemRead = Asserted;
			MemWrite = Not_Asserted;
			MemToReg = Asserted;
			RegWrite = Asserted;
			ALUimm = Not_Asserted;
		end

		// SW
		4'b1001: begin
			MemRead = Not_Asserted;
			MemWrite = Asserted;
			MemToReg = Not_Asserted;
			RegToMem = Asserted;
			RegWrite = Not_Asserted;
			ALUimm = Not_Asserted;
		end

		// LHB
		4'b1010: begin
			MemRead = Not_Asserted;
			MemWrite = Not_Asserted;
			MemToReg = Not_Asserted;
			RegWrite = Asserted;
			ALUimm = Asserted;
		end

		// LLB
		4'b1011: begin
			MemRead = Not_Asserted;
			MemWrite = Not_Asserted;
			MemToReg = Not_Asserted;
			RegWrite = Asserted;
			ALUimm = Asserted;
		end

		// B
		4'b1100: begin
			MemRead = Not_Asserted;
			MemWrite = Not_Asserted;
			MemToReg = Not_Asserted;
			RegWrite = Not_Asserted;
			ALUimm = Not_Asserted;
		end

		// BR
		4'b1101: begin
			MemRead = Not_Asserted;
			MemWrite = Not_Asserted;
			MemToReg = Not_Asserted;
			RegWrite = Not_Asserted;
			ALUimm = Not_Asserted;
		end

		// PCS
		4'b1110: begin
			MemRead = Not_Asserted;
			MemWrite = Not_Asserted;
			MemToReg = Not_Asserted;
			RegWrite = Asserted;
			ALUimm = Not_Asserted;
		end

		// HLT
		4'b1111: begin
			MemRead = Not_Asserted;
			MemWrite = Not_Asserted;
			MemToReg = Not_Asserted;
			RegWrite = Not_Asserted;
			ALUimm = Not_Asserted;
		end
		default:  begin
			MemRead = Not_Asserted;
			MemWrite = Not_Asserted;
			MemToReg = Not_Asserted;
			RegWrite = Not_Asserted;
			ALUimm = Not_Asserted;
		end
	endcase
end
endmodule