module RED_16b(input[15:0] SrcData1, input[15:0] SrcData2, output[15:0] DesData);

wire[6:0] pg, gg;
wire[3:0] reg11, reg22, reg33, reg44, reg12, reg34, reg1234;
wire[4:0] cout_csa;
wire[4:0] sum_1bcsa;
wire[1:0] sum_2bcsa;
wire[1:0] cout_2bcsa;
wire[3:0] sum_4bcsa;
wire[3:0] cout_4bcsa;

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
CLA_4b add6(.a(reg12), .b(reg34), .c_in(1'b0), .pg_out(pg[6]), .gg_out(gg[6]), .s(reg1234));

//
// Sum all carries from CLAs, using wallace tree of CSAs
//
//
// Level 1, three 1bit CSAs
//
full_adder_1b FA10(.a(gg[0]), .b(gg[1]), .cin(1'b0), .s(sum_1bcsa[0]), .cout(cout_csa[0]));
full_adder_1b FA11(.a(gg[2]), .b(gg[3]), .cin(1'b0), .s(sum_1bcsa[1]), .cout(cout_csa[1]));
full_adder_1b FA12(.a(gg[6]), .b(gg[4]), .cin(gg[5]), .s(sum_1bcsa[2]), .cout(cout_csa[2]));

//
// Level 2, two 1bit CSAs
//
full_adder_1b FA13(.a(cout_csa[0]), .b(cout_csa[1]), .cin(cout_csa[2]), .s(sum_1bcsa[3]), .cout(cout_csa[3]));
full_adder_1b FA14(.a(sum_1bcsa[0]), .b(sum_1bcsa[1]), .cin(sum_1bcsa[2]), .s(sum_1bcsa[4]), .cout(cout_csa[4]));
//
// Level 3, one 2bit CSA
//
CSA_2b csa20(.x({{1'b0},cout_csa[3]}<<1), .y({{1'b0},{sum_1bcsa[3]}}), .z({{1'b0},{cout_csa[4]}}), .s(sum_2bcsa), .cout(cout_2bcsa));
//
// Level 4, one 4bit FA
//
CSA_4b csa40(.x({{2'b0},{cout_2bcsa}}<<2), .y({{2'b0},{sum_2bcsa}}<<1), .z({{3'b0},{sum_1bcsa[4]}}), .s(sum_4bcsa), .cout(cout_4bcsa));

assign DesData = {{9{sum_4bcsa[2]}},{sum_4bcsa[2:0]},{reg1234}};

endmodule // RED_16b


module CSA_2b(input[1:0] x,y,z, output[1:0] s, output[1:0] cout);          

full_adder_1b fa_inst10(x[0],y[0],z[0],cout[0],s[0]);
full_adder_1b fa_inst11(x[1],y[1],z[1],cout[1],s[1]);

endmodule


module CSA_4b(input[3:0] x,y,z, output[3:0] s, output[3:0] cout);

full_adder_1b fa_inst10(x[0],y[0],z[0],cout[0],s[0]);
full_adder_1b fa_inst11(x[1],y[1],z[1],cout[1],s[1]);
full_adder_1b fa_inst12(x[2],y[2],z[2],cout[2],s[2]);
full_adder_1b fa_inst13(x[3],y[3],z[3],cout[3],s[3]); 

endmodule

