module PC_control(
		input [2:0]C,
		input [8:0]I, 
		input [2:0]F, 
		input hlt,
		input [15:0]PC_in,
		output [15:0]PC_out
);

wire [15:0] normal;
wire [15:0] branch;
reg [15:0] out;

full_adder addr1(.Sum(normal), .A(PC_in), .B(9'h002));
full_adder addr2(.Sum(branch), .A(normal), .B(I));

assign PC_out = (hlt)? PC_in:out;
always@(*) begin
	case(C)
		3'b000: assign out = (F[2] == 1'b0)? branch: normal; 
		3'b001: assign out = (F[2] == 1'b1)? branch: normal;
		3'b010: assign out = (F[2] == 1'b1)? normal: (F[0] == 1'b0)? branch: normal;
		3'b011: assign out = (F[0] == 1'b1)? branch: normal;
		3'b100: assign out = (F[2] == 1'b1)? branch: (F[0] == 1'b0)? branch: normal; 
		3'b101: assign out = (F[2] == 1'b1)? branch: (F[0] == 1'b1)? branch: normal;
		3'b110: assign out = (F[1] == 1'b1)? branch: normal;
		3'b111: assign out = branch;
		default out = normal;
	endcase
end

endmodule
