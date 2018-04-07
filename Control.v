module CTRL_UNIT(
	input  [3:0]instruction,
	// output reg RegDst,
	output reg MemRead,
	output reg MemtoReg,
	output reg MemWrite,
	output reg ALUSrc,
	output reg RegWrite,
	output reg hlt,
	output reg pcs,
	output reg ALUOp,
	output reg tophalf
);

localparam Asserted = 1'b1;
localparam Not_Asserted = 1'b0;

always@(*) begin
	case(instruction)
		// Add
		4'b0000: begin
			//RegDst = Asserted;
			MemRead = Not_Asserted;
			MemtoReg = Not_Asserted;
			MemWrite = Not_Asserted;
			ALUSrc = Not_Asserted;
			RegWrite = Asserted;
			hlt = Not_Asserted;
			pcs = Not_Asserted;
			ALUOp = Asserted;
			tophalf = Not_Asserted;
		end

		// Sub
		4'b0001: begin
			//RegDst = Asserted;
			MemRead = Not_Asserted;
			MemtoReg = Not_Asserted;
			MemWrite = Not_Asserted;
			ALUSrc = Not_Asserted;
			RegWrite = Asserted;
			hlt = Not_Asserted;
			pcs = Not_Asserted;
			ALUOp = Asserted;
			tophalf = Not_Asserted;
		end

		// Red
		4'b0010: begin
			//RegDst = Asserted;
			MemRead = Not_Asserted;
			MemtoReg = Not_Asserted;
			MemWrite = Not_Asserted;
			ALUSrc = Not_Asserted;
			RegWrite = Asserted;
			hlt = Not_Asserted;
			pcs = Not_Asserted;
			ALUOp = Asserted;
			tophalf = Not_Asserted;
		end

		// XOR
		4'b0011: begin
			//RegDst = Asserted;
			MemRead = Not_Asserted;
			MemtoReg = Not_Asserted;
			MemWrite = Not_Asserted;
			ALUSrc = Not_Asserted;
			RegWrite = Asserted;
			hlt = Not_Asserted;
			pcs = Not_Asserted;
			ALUOp = Asserted;
			tophalf = Not_Asserted;
		end

		// SLL
		4'b0100: begin
			//RegDst = Asserted;
			MemRead = Not_Asserted;
			MemtoReg = Not_Asserted;
			MemWrite = Not_Asserted;
			ALUSrc = Asserted;
			RegWrite = Asserted;
			hlt = Not_Asserted;
			pcs = Not_Asserted;
			ALUOp = Asserted;
			tophalf = Not_Asserted;
		end

		// SRA
		4'b0101: begin
			//RegDst = Asserted;
			MemRead = Not_Asserted;
			MemtoReg = Not_Asserted;
			MemWrite = Not_Asserted;
			ALUSrc = Asserted;
			RegWrite = Asserted;
			hlt = Not_Asserted;
			pcs = Not_Asserted;
			ALUOp = Asserted;
			tophalf = Not_Asserted;
		end

		// ROR
		4'b0110: begin
			//RegDst = Asserted;
			MemRead = Not_Asserted;
			MemtoReg = Not_Asserted;
			MemWrite = Not_Asserted;
			ALUSrc = Asserted;
			RegWrite = Asserted;
			hlt = Not_Asserted;
			pcs = Not_Asserted;
			ALUOp = Asserted;
			tophalf = Not_Asserted;
		end

		// PADDSB
		4'b0111: begin
			//RegDst = Asserted;
			MemRead = Not_Asserted;
			MemtoReg = Not_Asserted;
			MemWrite = Not_Asserted;
			ALUSrc = Not_Asserted;
			RegWrite = Asserted;
			hlt = Not_Asserted;
			pcs = Not_Asserted;
			ALUOp = Asserted;
			tophalf = Not_Asserted;
		end

		// LW
		4'b1000: begin
			//RegDst = Asserted;
			MemRead = Asserted;
			MemtoReg = Asserted;
			MemWrite = Not_Asserted;
			ALUSrc = Asserted;
			RegWrite = Asserted;
			hlt = Not_Asserted;
			pcs = Not_Asserted;
			ALUOp = Not_Asserted;
			tophalf = Not_Asserted;
		end

		// SW
		4'b1001: begin
			//RegDst = Not_Asserted;
			MemRead = Not_Asserted;
			MemtoReg = Not_Asserted;
			MemWrite = Asserted;
			ALUSrc = Asserted;
			RegWrite = Not_Asserted;
			hlt = Not_Asserted;
			pcs = Not_Asserted;
			ALUOp = Not_Asserted;
			tophalf = Not_Asserted;
		end

		// LHB
		4'b1010: begin
			//RegDst = Asserted;
			MemRead = Not_Asserted;
			MemtoReg = Not_Asserted;
			MemWrite = Not_Asserted;
			ALUSrc = Asserted;
			RegWrite = Asserted;
			hlt = Not_Asserted;
			pcs = Not_Asserted;
			ALUOp = Not_Asserted;
			tophalf = Asserted;
		end

		// LLB
		4'b1011: begin
			//RegDst = Asserted;
			MemRead = Not_Asserted;
			MemtoReg = Not_Asserted;
			MemWrite = Not_Asserted;
			ALUSrc = Asserted;
			RegWrite = Asserted;
			hlt = Not_Asserted;
			pcs = Not_Asserted;
			ALUOp = Not_Asserted;
			tophalf = Not_Asserted;
		end

		// B
		4'b1100: begin
			//RegDst = Not_Asserted;
			MemRead = Not_Asserted;
			MemtoReg = Not_Asserted;
			MemWrite = Not_Asserted;
			ALUSrc = Not_Asserted;
			RegWrite = Not_Asserted;
			hlt = Not_Asserted;
			pcs = Not_Asserted;
			ALUOp = Not_Asserted;
			tophalf = Not_Asserted;
		end

		// BR
		4'b1101: begin
			//RegDst = Not_Asserted;
			MemRead = Not_Asserted;
			MemtoReg = Not_Asserted;
			MemWrite = Not_Asserted;
			ALUSrc = Not_Asserted;
			RegWrite = Not_Asserted;
			hlt = Not_Asserted;
			pcs = Not_Asserted;
			ALUOp = Not_Asserted;
			tophalf = Not_Asserted;
		end

		// PCS
		4'b1110: begin
			//RegDst = Asserted;
			MemRead = Not_Asserted;
			MemtoReg = Not_Asserted;
			MemWrite = Not_Asserted;
			ALUSrc = Not_Asserted;
			RegWrite = Asserted;
			hlt = Not_Asserted;
			pcs = Asserted;
			ALUOp = Not_Asserted;
			tophalf = Not_Asserted;
		end

		// HLT
		4'b1111: begin
			//RegDst = Not_Asserted;
			MemRead = Not_Asserted;
			MemtoReg = Not_Asserted;
			MemWrite = Not_Asserted;
			ALUSrc = Not_Asserted;
			RegWrite = Not_Asserted;
			hlt = Asserted;
			pcs = Not_Asserted;
			ALUOp = Not_Asserted;
			tophalf = Not_Asserted;
		end
		default:  begin
			//RegDst = Not_Asserted;
			MemRead = Not_Asserted;
			MemtoReg = Not_Asserted;
			MemWrite = Not_Asserted;
			ALUSrc = Not_Asserted;
			RegWrite = Not_Asserted;
			hlt = Asserted;
			pcs = Not_Asserted;
			ALUOp = Not_Asserted;
			tophalf = Not_Asserted;
		end
	endcase
end
endmodule