module ALU_tb();

	logic	[15:0]	ALU_in1, ALU_in2;
	logic	[2:0]	op;
	logic	[15:0]	ALU_out;
	logic	[2:0]	flag;
	logic   [2:0]	flag_write;

ALU DUT(.ALU_in1(ALU_in1), .ALU_in2(ALU_in2), .op(op), .ALU_out(ALU_out), .flag(flag), .flag_write(flag_write));
	
initial begin
	ALU_in1 = 16'h0000;
	ALU_in2 = 16'hffff;
	op = 3'b000;
	
	repeat(8) begin
		#100
		$display("ALU_out : %h \n flag: %b \n flag_write : %b \n", ALU_out, flag, flag_write);
		op++;
	end

	ALU_in1 = 16'h8fff;
	ALU_in2 = 16'h8fff;
	repeat(8) begin
		#100
		$display("ALU_out : %h \n flag: %h \n flag_write : %b \n", ALU_out, flag, flag_write);
		op++;
	end
end

endmodule