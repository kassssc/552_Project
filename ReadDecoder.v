module ReadDecoder_4_16(
	input [3:0] RegId, 
	output [15:0] Wordline
);
	assign Wordline =   (RegId == 4'b0000) ? 16'h0001:
						(RegId == 4'b0001) ? 16'h0002:
						(RegId == 4'b0010) ? 16'h0004:
						(RegId == 4'b0011) ? 16'h0008:
						(RegId == 4'b0100) ? 16'h0010:
						(RegId == 4'b0101) ? 16'h0020:
						(RegId == 4'b0110) ? 16'h0040:
						(RegId == 4'b0111) ? 16'h0080:
						(RegId == 4'b1000) ? 16'h0100:
						(RegId == 4'b1001) ? 16'h0200:
						(RegId == 4'b1010) ? 16'h0400:
						(RegId == 4'b1011) ? 16'h0800:
						(RegId == 4'b1100) ? 16'h1000:
						(RegId == 4'b1101) ? 16'h2000:
						(RegId == 4'b1110) ? 16'h4000:16'h8000;			
endmodule
