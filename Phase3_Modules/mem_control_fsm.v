module mem_control_fsm(
	input clk,
	input rst,
	input I_CacheBusy,
	input D_CacheBusy,
	input I_cache_finished,
	input D_cache_finished,
	output I_mem_fetch,
	output D_mem_fetch,
	output [1:0]state_out
);


wire [1:0] state;
reg [1:0] state_new;



always@(*) begin
	casex ({I_CacheBusy, D_CacheBusy, state})
		4'b0000: state_new = 2'b00;
		4'b1x00: state_new = 2'b01;
		4'b1x01: state_new = 2'b01;
		4'b0101: state_new = 2'b10;
		4'bx110: state_new = 2'b10;
		4'b0100: state_new = 2'b10;
		4'b0010: state_new = 2'b00;
		4'b0001: state_new = 2'b00;
		4'b1010: state_new = 2'b01;
		default state_new = 2'b00;
	endcase
end // always@(*)



assign I_mem_fetch = (state_new == 2'b01)? 1'b1:1'b0;
assign D_mem_fetch = (state_new == 2'b10)? 1'b1:1'b0;
assign state_out = state_new;


dff ff0(.d(state_new[0]), .q(state[0]), .wen(1'b1), .clk(clk), .rst(rst));
dff ff1(.d(state_new[1]), .q(state[1]), .wen(1'b1), .clk(clk), .rst(rst));

endmodule



