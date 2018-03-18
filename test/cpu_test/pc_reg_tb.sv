module pc_reg_tb();

logic [15:0] pc_new;
logic clk;
logic rst;
logic [15:0] pc_current;

PC_Register DUT(.PC_new(pc_new), .clk(clk), .rst(rst), .PC_current(pc_current));

always #100 clk = ~clk;


initial begin 
	clk = 1'b0;
	rst = 1'b1;
	#50
	
	rst = 1'b0;
	#50
	
	repeat(20) begin
		#20
		pc_new = $random();
	
		$display("pc_current : %h", pc_current);
	end
end

endmodule
	
	