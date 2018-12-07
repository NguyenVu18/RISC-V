module CLA_1(ai, bi, ci, Pi, Gi, Si);
input ai, bi, ci;
output Pi, Gi, Si;

or U1(Pi, ai, bi);

xor U2(Si, ai, bi, ci);
and U3(Gi, ai, bi);
endmodule
