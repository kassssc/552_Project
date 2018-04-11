module forward (
	input ex_mem_regwrite,
	input mem_wb_regwrite,
	input [3:0] ex_mem_regdest,
	input [3:0] mem_wb_regdest,
	input [3:0] id_ex_regrs,
	input [3:0] id_ex_regrt,
	output [1:0] forwardA,
	output [1:0] forwardB
);

wire [1:0] ex_hazard;
wire [1:0] mem_hazard;


assign ex_hazard[0] = ex_mem_regwrite & (ex_mem_regdest != 4'h0) & (ex_mem_regdest == id_ex_regrs);
assign ex_hazard[1] = ex_mem_regwrite & (ex_mem_regdest != 4'h0) & (ex_mem_regdest == id_ex_regrt);
assign mem_hazard[0] = mem_wb_regwrite & (mem_wb_regdest != 4'h0) & ~ex_hazard[0] & (mem_wb_regdest == id_ex_regrs);
assign mem_hazard[1] = mem_wb_regwrite & (mem_wb_regdest != 4'h0) & ~ex_hazard[1] & (mem_wb_regdest == id_ex_regrt);

assign forwardB = ex_hazard[0] ? 2'b10 : (mem_hazard[0] ? 2'b01 : 2'b0);
assign forwardA = ex_hazard[1] ? 2'b10 : (mem_hazard[1] ? 2'b01 : 2'b0);


endmodule // forward

/*
1. EX hazard:

if (EX/MEM.RegWrite
and (EX/MEM.RegisterRd ≠ 0)
and (EX/MEM.RegisterRd = ID/EX.RegisterRs)) ForwardA = 10

if (EX/MEM.RegWrite
and (EX/MEM.RegisterRd ≠ 0)
and (EX/MEM.RegisterRd = ID/EX.RegisterRt)) ForwardB = 10

2. MEM hazard:

if (MEM/WB.RegWrite
and (MEM/WB.RegisterRd ≠  0)
and not(EX/MEM.RegWrite and EX/MEM.RegDest != 0)
and (EX/MEM.RegRd == ID/EX.RegRs)
and (MEM/WB.RegisterRd = ID/EX.RegisterRs)) ForwardA = 01

if (MEM/WB.RegWrite
and (MEM/WB.RegisterRd ≠  0)
and not(EX/MEM.RegWrite and EX/MEM.RegDest != 0)
and (EX/MEM.RegRd == ID/EX.RegRt)
and (MEM/WB.RegisterRd = ID/EX.RegisterRt)) ForwardB = 01
*/
