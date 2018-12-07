module add32bit(a,b,cin,out,cout);
input [31:0] a;
input [31:0] b;
input cin;
output [31:0] out;
output cout;
wire [31:0] a;
wire [31:0] b;
wire cin, cout;
wire [31:0] out;
wire [31:0] c_out;
add_bit add0 (a[0],b[0],cin,out[0],c_out[0]);
add_bit add1 (a[1],b[1],c_out[0],out[1],c_out[1]);
add_bit add2 (a[2],b[2],c_out[1],out[2],c_out[2]);
add_bit add3 (a[3],b[3],c_out[2],out[3],c_out[3]);
add_bit add4 (a[4],b[4],c_out[3],out[4],c_out[4]);
add_bit add5 (a[5],b[5],c_out[4],out[5],c_out[5]);
add_bit add6 (a[6],b[6],c_out[5],out[6],c_out[6]);
add_bit add7 (a[7],b[7],c_out[6],out[7],c_out[7]);
add_bit add8 (a[8],b[8],c_out[7],out[8],c_out[8]);
add_bit add9 (a[9],b[9],c_out[8],out[9],c_out[9]);
add_bit add10 (a[10],b[10],c_out[9],out[10],c_out[10]);
add_bit add11 (a[11],b[11],c_out[10],out[11],c_out[11]);
add_bit add12 (a[12],b[12],c_out[11],out[12],c_out[12]);
add_bit add13 (a[13],b[13],c_out[12],out[13],c_out[13]);
add_bit add14 (a[14],b[14],c_out[13],out[14],c_out[14]);
add_bit add15 (a[15],b[15],c_out[14],out[15],c_out[15]);
add_bit add16 (a[16],b[16],c_out[15],out[16],c_out[16]);
add_bit add17 (a[17],b[17],c_out[16],out[17],c_out[17]);
add_bit add18 (a[18],b[18],c_out[17],out[18],c_out[18]);
add_bit add19 (a[19],b[19],c_out[18],out[19],c_out[19]);
add_bit add20 (a[20],b[20],c_out[19],out[20],c_out[20]);
add_bit add21 (a[21],b[21],c_out[20],out[21],c_out[21]);
add_bit add22 (a[22],b[22],c_out[21],out[22],c_out[22]);
add_bit add23 (a[23],b[23],c_out[22],out[23],c_out[23]);

add_bit add24 (a[24],b[24],c_out[23],out[24],c_out[24]);
add_bit add25 (a[25],b[25],c_out[24],out[25],c_out[25]);
add_bit add26 (a[26],b[26],c_out[25],out[26],c_out[26]);
add_bit add27 (a[27],b[27],c_out[26],out[27],c_out[27]);
add_bit add28 (a[28],b[28],c_out[27],out[28],c_out[28]);
add_bit add29 (a[29],b[29],c_out[28],out[29],c_out[29]);
add_bit add30 (a[30],b[30],c_out[29],out[30],c_out[30]);
add_bit add31 (a[31],b[31],c_out[30],out[31],c_out[31]);

endmodule

