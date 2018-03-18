module RED_16b(input[15:0] SrcData1, input[15:0] SrcData2, output[15:0] DesData);

wire[15:0] reg10, reg14, reg18, reg112;
wire[3:0] reg20, reg24;
wire[6:0] cout;

full_adder_16bit FA0(.A({16{SrcData1[3:0]}}), .B({16{SrcData2[3:0]}}), .Cin(1'b0), .Sum(reg10), .Cout(cout[0]));
full_adder_16bit FA1(.A({16{SrcData1[7:4]}}), .B({16{SrcData2[7:4]}}), .Cin(1'b0), .Sum(reg14), .Cout(cout[1]));
full_adder_16bit FA2(.A({16{SrcData1[11:8]}}), .B({16{SrcData2[11:8]}}), .Cin(1'b0), .Sum(reg18), .Cout(cout[2]));
full_adder_16bit FA3(.A({16{SrcData1[15:12]}}), .B({16{SrcData2[15:12]}}), .Cin(1'b0), .Sum(reg112), .Cout(cout[3]));
full_adder_16bit FA4(.A(reg10), .B(reg14), .Cin(1'b0), .Sum(reg20), .Cout(cout[4]));
full_adder_16bit FA5(.A(reg18), .B(reg112), .Cin(1'b0), .Sum(reg24), .Cout(cout[5]));
full_adder_16bit FA6(.A(reg20), .B(reg24), .Cin(1'b0), .Sum(DesData), .Cout(cout[6]));

endmodule // RED_16b
