module add_bit(a,b,ci,sum,co);
input a;
input b;
input ci;
output sum;
output co;
wire a,b,ci,sum,co;
assign sum = a^b^ci;
assign co  = (a&b)|(a&ci)|(b&ci);
endmodule

