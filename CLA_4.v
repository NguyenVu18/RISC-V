module CLA_4(A, B, Ci, S, GG, PP);
input [3:0] A, B;
input Ci;
output [3:0] S;
output GG, PP;

wire C1, C2, C3, G0, G1, G2, G3, P0, P1, P2, P3;
wire [13:0] temp;
CLA_1 	U0(.ai(A[0]), .bi(B[0]), .ci(Ci), .Pi(P0), .Gi(G0), .Si(S[0]));
CLA_1 	U1(.ai(A[1]), .bi(B[1]), .ci(C1), .Pi(P1), .Gi(G1), .Si(S[1]));
CLA_1 	U2(.ai(A[2]), .bi(B[2]), .ci(C2), .Pi(P2), .Gi(G2), .Si(S[2]));
CLA_1 	U3(.ai(A[3]), .bi(B[3]), .ci(C3), .Pi(P3), .Gi(G3), .Si(S[3]));

//C1=G0+P0C0
and 		U4(temp[0], P0, Ci);
or			U5(C1, G0, temp[0]);
//C2=G1+P1G0+P1P0C0
and		U6(temp[1], P1, G0);
and		U7(temp[2], P1, P0, Ci);
or			U8(C2, temp[1], temp[2], G1);
//C3=G2+P2G1+P2P1G0+P2P1P0C0
and		U9(temp[3], P2, G1);
and		U10(temp[4], P2, P1, G0);
and		U11(temp[5], P2, P1, P0);
and		U12(temp[6], temp[5], Ci);
or			U13(temp[7], G2, temp[3], temp[4]);
or			U14(C3, temp[7], temp[6]);
//Generation PP=P3P2P1P0, GG=G3+P3G2+P3P2G1+P3P2P1G0
and 		U15(temp[8], P3, P2, P1);
and		U16(PP, temp[8], P0);
and		U17(temp[9], G2, P3);//P3G2
and		U18(temp[10], G1, P2, P3);//P3P2G1
and		U19(temp[11], P3, P1, P2);//P3P2P1
and		U20(temp[12], temp[11], G0); //P3P2P1G0
or		U23(temp[13], G3, temp[9], temp[10]);//G3+P3G2+P3P2G1
or		U21(GG, temp[13], temp[12]);
endmodule