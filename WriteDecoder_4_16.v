module WriteDecoder_4_16(
	input [3:0] RegId,
	input WriteReg,
	output [15:0] Wordline
);

assign Wordline =   (RegId == 4'b0000) ? 16'h0001 & {16{WriteReg}}:
					(RegId == 4'b0001) ? 16'h0002 & {16{WriteReg}}:
					(RegId == 4'b0010) ? 16'h0004 & {16{WriteReg}}:
					(RegId == 4'b0011) ? 16'h0008 & {16{WriteReg}}:
					(RegId == 4'b0100) ? 16'h0010 & {16{WriteReg}}:
					(RegId == 4'b0101) ? 16'h0020 & {16{WriteReg}}:
					(RegId == 4'b0110) ? 16'h0040 & {16{WriteReg}}:
					(RegId == 4'b0111) ? 16'h0080 & {16{WriteReg}}:
					(RegId == 4'b1000) ? 16'h0100 & {16{WriteReg}}:
					(RegId == 4'b1001) ? 16'h0200 & {16{WriteReg}}:
					(RegId == 4'b1010) ? 16'h0400 & {16{WriteReg}}:
					(RegId == 4'b1011) ? 16'h0800 & {16{WriteReg}}:
					(RegId == 4'b1100) ? 16'h1000 & {16{WriteReg}}:
					(RegId == 4'b1101) ? 16'h2000 & {16{WriteReg}}:
					(RegId == 4'b1110) ? 16'h4000 & {16{WriteReg}}: 16'h8000 & {16{WriteReg}};	

endmodule