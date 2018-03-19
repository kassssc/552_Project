module pc_reg_tb();

logic [15:0] pc_new;
logic clk;
logic rst;
logic [15:0] pc_current;

PC_Register DUT(.PC_new(pc_new), .clk(clk), .rst(rst), .PC_current(pc_current));


always #50 clk = ~clk;

initial begin 
	clk = 1;
	rst = 1;
	#201
	
	rst = 0;

	repeat(20) begin
		#101
		pc_new = $random();
	
		$display("input:%h\noutput:%h\n", pc_new, pc_current);
	end
end

endmodule
	
	