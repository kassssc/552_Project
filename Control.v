module CTRL_UNIT(
	input  [3:0]instr,
	input  flush,
	output reg MemWrite,
	output reg MemToReg,
	output reg RegWrite,
	output reg ALUimm,
);

localparam Asserted = 1'b1 & ~flush;
localparam Not_Asserted = 1'b0;

always@(*) begin
	case(instr)
		// Add
		4'b0000: begin
			MemWrite = Not_Asserted;
			MemToReg = Not_Asserted;
			RegWrite = Asserted;
			ALUimm = Not_Asserted;
		end

		// Sub
		4'b0001: begin
			MemWrite = Not_Asserted;
			MemToReg = Not_Asserted;
			RegWrite = Asserted;
			ALUimm = Not_Asserted;
		end

		// Red
		4'b0010: begin
			MemWrite = Not_Asserted;
			MemToReg = Not_Asserted;
			RegWrite = Asserted;
			ALUimm = Not_Asserted;
		end

		// XOR
		4'b0011: begin
			MemWrite = Not_Asserted;
			MemToReg = Not_Asserted;
			RegWrite = Asserted;
			ALUimm = Not_Asserted;
		end

		// SLL
		4'b0100: begin
			MemWrite = Not_Asserted;
			MemToReg = Not_Asserted;
			RegWrite = Asserted;
			ALUimm = Asserted;
		end

		// SRA
		4'b0101: begin
			MemWrite = Not_Asserted;
			MemToReg = Not_Asserted;
			RegWrite = Asserted;
			ALUimm = Asserted;
		end

		// ROR
		4'b0110: begin
			MemWrite = Not_Asserted;
			MemToReg = Not_Asserted;
			RegWrite = Asserted;
			ALUimm = Asserted;
		end

		// PADDSB
		4'b0111: begin
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
			MemWrite = Asserted;
			MemToReg = Not_Asserted;
			RegWrite = Not_Asserted;
			ALUimm = Not_Asserted;
		end

		// LHB
		4'b1010: begin
			MemWrite = Not_Asserted;
			MemToReg = Not_Asserted;
			RegWrite = Asserted;
			ALUimm = Asserted;
		end

		// LLB
		4'b1011: begin
			MemWrite = Not_Asserted;
			MemToReg = Not_Asserted;
			RegWrite = Asserted;
			ALUimm = Asserted;
		end

		// B
		4'b1100: begin
			MemWrite = Not_Asserted;
			MemToReg = Not_Asserted;
			RegWrite = Not_Asserted;
			ALUimm = Not_Asserted;
		end

		// BR
		4'b1101: begin
			MemWrite = Not_Asserted;
			MemToReg = Not_Asserted;
			RegWrite = Not_Asserted;
			ALUimm = Not_Asserted;
		end

		// PCS
		4'b1110: begin
			MemWrite = Not_Asserted;
			MemToReg = Not_Asserted;
			RegWrite = Asserted;
			ALUimm = Not_Asserted;
		end

		// HLT
		4'b1111: begin
			MemWrite = Not_Asserted;
			MemToReg = Not_Asserted;
			RegWrite = Not_Asserted;
			ALUimm = Not_Asserted;
		end
		default:  begin
			MemWrite = Not_Asserted;
			MemToReg = Not_Asserted;
			RegWrite = Not_Asserted;
			ALUimm = Not_Asserted;
		end
	endcase
end
endmodule