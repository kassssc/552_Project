module mem_control_fsm(
	input clk,
	input rst,
	input I_cacheBusy,
	input D_cacheBusy,
	input I_cache_finished,
	input D_cache_finished,
	output I_mem_fetch,
	output D_mem_fetch
);

wire I_is_8, D_is_8;

wire [1:0] state;
reg [1:0] state_new;

assign I_mem_fetch = (state == 2'b01)? 1'b1:1'b0;
assign D_mem_fetch = (state == 2'b10)? 1'b1:1'b0;


always@(*) begin
	casex ({I_cacheBusy, I_cache_finished, D_cacheBusy, D_cache_finished, state})
		6'b000000: state_new = 2'b00;
		6'b1xxx00: state_new = 2'b01;
		6'b10xx01: state_new = 2'b01;
		6'b110x01: state_new = 2'b00;
		6'b111x01: state_new = 2'b10;
		6'b0x1x00: state_new = 2'b10;
		6'bxx1010: state_new = 2'b10;
		6'b0x1110: state_new = 2'b00;
		6'b1x1110: state_new = 2'b01;
	endcase
end // always@(*)

dff ff0(.d(state_new[0]), .q(state[0]), .wen(1'b1), .clk(clk), .rst(rst));
dff ff1(.d(state_new[1]), .q(state[1]), .wen(1'b1), .clk(clk), .rst(rst));

endmodule



