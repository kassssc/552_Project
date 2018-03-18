module RED_16b(input[15:0] SrcData1, input[15:0] SrcData2, output[15:0] DesData);

wire[6:0] pg, gg;
wire[3:0] reg11, reg22, reg33, reg44, reg12, reg34, reg1234;
wire[5:0] cout_csa;
wire[3:0] sum_1bcsa;
wire[1:0] sum_2bcsa;
wire[3:0] sum_4bcsa;
wire[6:0] cout;

//
// Tree of CLAs
//
//
// First level
//
CLA_4b add0(.a(SrcData1[3:0]), .b(SrcData2[3:0]), .c_in(1'b0), .pg_out(pg[0]), .gg_out(gg[0]), .s(reg11));
CLA_4b add1(.a(SrcData1[7:4]), .b(SrcData2[7:4]), .c_in(1'b0), .pg_out(pg[1]), .gg_out(gg[1]), .s(reg22));
CLA_4b add2(.a(SrcData1[11:8]), .b(SrcData2[11:8]), .c_in(1'b0), .pg_out(pg[2]), .gg_out(gg[2]), .s(reg33));
CLA_4b add3(.a(SrcData1[15:12]), .b(SrcData2[15:12]), .c_in(1'b0), .pg_out(pg[3]), .gg_out(gg[3]), .s(reg44));
//
// Second level
//
CLA_4b add4(.a(reg11), .b(reg22), .c_in(1'b0), .pg_out(pg[4]), .gg_out(gg[4]), .s(reg12));
CLA_4b add5(.a(reg33), .b(reg44), .c_in(1'b0), .pg_out(pg[5]), .gg_out(gg[5]), .s(reg34));
//
// Third level
//
CLA_4b add4(.a(reg12), .b(reg34), .c_in(1'b0), .pg_out(pg[6]), .gg_out(gg[6]), .s(reg1234));
//
// Sum all carries from CLAs, using wallace tree of CSAs
//
//
// Level 1, two 1bit FAs
//
full_adder_1bit FA10(.A(gg[0]), .B(gg[1]), .Cin(gg[2]), .S(sum_1bcsa[0]), .Cout(cout_csa[0]));
full_adder_1bit FA11(.A(gg[3]), .B(gg[4]), .Cin(gg[5]), .S(sum_1bcsa[1]), .Cout(cout_csa[1]));
//
// Level 2, two 1bit FAs
//
full_adder_1bit FA12(.A(cout_csa[0]), .B(sum_1bcsa[0]), .Cin(gg[6]), .S(sum_1bcsa[2]), .Cout(cout_csa[2]));
full_adder_1bit FA13(.A(cout_csa[1]), .B(sum_1bcsa[1]), .Cin(1'b0), .S(sum_1bcsa[3]), .Cout(cout_csa[3]));
//
// Level 3, one 2bit FA
//
full_adder_2b FA20(.A(cout_csa[2]<<1), .B({1'b0{sum_1bcsa[2]}}), .Cin({1'b0{cout_csa[3]}}), .S(sum_2bcsa), .Cout(cout_csa[4]));
//
// Level 4, one 4bit FA
//
full_adder_4b FA40(.A({1'b0{cout_csa[4]<<2}}), .B({1'b0{sum_2bcsa<<1}}), .Cin({2'b0{sum_1bcsa[3]}}), .S(sum_4bcsa), .Cout(cout_csa[5]));

assign DesData = {16{sum_4bcsa}};

endmodule // RED_16b
