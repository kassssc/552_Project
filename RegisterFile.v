module RegisterFile(
	input clk, 
	input rst, 
	input [3:0] SrcReg1, 
	input [3:0] SrcReg2, 
	input [3:0] DstReg, 
	input WriteReg, 
	input [15:0] DstData, 
	inout [15:0] SrcData1, 
	inout [15:0] SrcData2
);

wire [15:0]WriteWordline;
wire [15:0]ReadWordline1;
wire [15:0]ReadWordline2;
wire [15:0]Bitline1[15:0];
wire [15:0]Bitline2[15:0];
wire [15:0]Bitline_all1;
wire [15:0]Bitline_all2;

assign Bitline_all1 = Bitline1[0]|Bitline1[1]|Bitline1[2]|Bitline1[3]|Bitline1[4]|Bitline1[5]|Bitline1[6]|Bitline1[7]|Bitline1[8]|Bitline1[9]|Bitline1[10]|Bitline1[11]|Bitline1[12]|Bitline1[13]|Bitline1[14]|Bitline1[15];
assign Bitline_all2 = Bitline2[0]|Bitline2[1]|Bitline2[2]|Bitline2[3]|Bitline2[4]|Bitline2[5]|Bitline2[6]|Bitline2[7]|Bitline2[8]|Bitline2[9]|Bitline2[10]|Bitline2[11]|Bitline2[12]|Bitline2[13]|Bitline2[14]|Bitline2[15];


assign SrcData1 = (WriteReg & (SrcReg1 == DstReg)) ? DstData : Bitline_all1;
assign SrcData2 = (WriteReg & (SrcReg1 == DstReg)) ? DstData : Bitline_all2;


	ReadDecoder_4_16 rd1(
        .RegId(SrcReg1),
        .Wordline(ReadWordline1)
        );

    ReadDecoder_4_16 rd2(
        .RegId(SrcReg2),
        .Wordline(ReadWordline2)
        );

    WriteDecoder_4_16 wd(
        .RegId(DstReg),
        .WriteReg(WriteReg),
        .Wordline(WriteWordline)
        );

    Register reg_0(
        .clk(clk),  
        .rst(rst), 
        .D(DstData), 
        .WriteReg(WriteWordline[0]),
        .ReadEnable1(ReadWordline1[0]), 
        .ReadEnable2(ReadWordline2[0]), 
        .Bitline1(Bitline1[0]), 
        .Bitline2(Bitline2[0])
        );
    Register reg_1(
        .clk(clk),  
        .rst(rst), 
        .D(DstData), 
        .WriteReg(WriteWordline[1]),
        .ReadEnable1(ReadWordline1[1]), 
        .ReadEnable2(ReadWordline2[1]), 
        .Bitline1(Bitline1[1]), 
        .Bitline2(Bitline2[1])
        );
    Register reg_2(
        .clk(clk),  
        .rst(rst), 
        .D(DstData), 
        .WriteReg(WriteWordline[2]),
        .ReadEnable1(ReadWordline1[2]), 
        .ReadEnable2(ReadWordline2[2]), 
        .Bitline1(Bitline1[2]), 
        .Bitline2(Bitline2[2])
        );
    Register reg_3(
        .clk(clk),  
        .rst(rst), 
        .D(DstData), 
        .WriteReg(WriteWordline[3]),
        .ReadEnable1(ReadWordline1[3]), 
        .ReadEnable2(ReadWordline2[3]), 
        .Bitline1(Bitline1[3]), 
        .Bitline2(Bitline2[3])
        );
    Register reg_4(
        .clk(clk),  
        .rst(rst), 
        .D(DstData), 
        .WriteReg(WriteWordline[4]),
        .ReadEnable1(ReadWordline1[4]), 
        .ReadEnable2(ReadWordline2[4]), 
        .Bitline1(Bitline1[4]), 
        .Bitline2(Bitline2[4])
        );
    Register reg_5(
        .clk(clk),  
        .rst(rst), 
        .D(DstData), 
        .WriteReg(WriteWordline[5]),
        .ReadEnable1(ReadWordline1[5]), 
        .ReadEnable2(ReadWordline2[5]), 
        .Bitline1(Bitline1[5]), 
        .Bitline2(Bitline2[5])
        );
    Register reg_6(
        .clk(clk),  
        .rst(rst), 
        .D(DstData), 
        .WriteReg(WriteWordline[6]),
        .ReadEnable1(ReadWordline1[6]), 
        .ReadEnable2(ReadWordline2[6]), 
        .Bitline1(Bitline1[6]), 
        .Bitline2(Bitline2[6])
        );
    Register reg_7(
        .clk(clk),  
        .rst(rst), 
        .D(DstData), 
        .WriteReg(WriteWordline[7]),
        .ReadEnable1(ReadWordline1[7]), 
        .ReadEnable2(ReadWordline2[7]), 
        .Bitline1(Bitline1[7]), 
        .Bitline2(Bitline2[7])
        );
    Register reg_8(
        .clk(clk),  
        .rst(rst), 
        .D(DstData), 
        .WriteReg(WriteWordline[8]),
        .ReadEnable1(ReadWordline1[8]), 
        .ReadEnable2(ReadWordline2[8]), 
        .Bitline1(Bitline1[8]), 
        .Bitline2(Bitline2[8])
        );
    Register reg_9(
        .clk(clk),  
        .rst(rst), 
        .D(DstData), 
        .WriteReg(WriteWordline[9]),
        .ReadEnable1(ReadWordline1[9]), 
        .ReadEnable2(ReadWordline2[9]), 
        .Bitline1(Bitline1[9]), 
        .Bitline2(Bitline2[9])
        );
    Register reg_10(
        .clk(clk),  
        .rst(rst), 
        .D(DstData), 
        .WriteReg(WriteWordline[10]),
        .ReadEnable1(ReadWordline1[10]), 
        .ReadEnable2(ReadWordline2[10]), 
        .Bitline1(Bitline1[10]), 
        .Bitline2(Bitline2[10])
        );
    Register reg_11(
        .clk(clk),  
        .rst(rst), 
        .D(DstData), 
        .WriteReg(WriteWordline[11]),
        .ReadEnable1(ReadWordline1[11]), 
        .ReadEnable2(ReadWordline2[11]), 
        .Bitline1(Bitline1[11]), 
        .Bitline2(Bitline2[11])
        );
    Register reg_12(
        .clk(clk),  
        .rst(rst), 
        .D(DstData), 
        .WriteReg(WriteWordline[12]),
        .ReadEnable1(ReadWordline1[12]), 
        .ReadEnable2(ReadWordline2[12]), 
        .Bitline1(Bitline1[12]), 
        .Bitline2(Bitline2[12])
        );
    Register reg_13(
        .clk(clk),  
        .rst(rst), 
        .D(DstData), 
        .WriteReg(WriteWordline[13]),
        .ReadEnable1(ReadWordline1[13]), 
        .ReadEnable2(ReadWordline2[13]), 
        .Bitline1(Bitline1[13]), 
        .Bitline2(Bitline2[13])
        );
    Register reg_14(
        .clk(clk),  
        .rst(rst), 
        .D(DstData), 
        .WriteReg(WriteWordline[14]),
        .ReadEnable1(ReadWordline1[14]), 
        .ReadEnable2(ReadWordline2[14]), 
        .Bitline1(Bitline1[14]), 
        .Bitline2(Bitline2[14])
        );
    Register reg_15(
        .clk(clk),  
        .rst(rst), 
        .D(DstData), 
        .WriteReg(WriteWordline[15]),
        .ReadEnable1(ReadWordline1[15]), 
        .ReadEnable2(ReadWordline2[15]), 
        .Bitline1(Bitline1[15]), 
        .Bitline2(Bitline2[15])
        );
endmodule


