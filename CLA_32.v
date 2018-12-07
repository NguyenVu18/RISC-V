module CLA_32(A, B, Cin, S, Co);
input [31:0] A, B;
input Cin;
output [31:0] S;
output Co;

wire [59:0] temp;
wire G0, G1, G2, G3, G4, G5, G6, G7, P0, P1, P2, P3, P4, P5, P6, P7, C1, C2, C3, C4, C5, C6,C7;


 CLA_4 U0(.A(A[3:0]), .B(B[3:0]), .Ci(Cin), .S(S[3:0]), .GG(G0), .PP(P0));
 CLA_4 U1(.A(A[7:4]), .B(B[7:4]), .Ci(C1), .S(S[7:4]), .GG(G1), .PP(P1));
 CLA_4 U2(.A(A[11:8]), .B(B[11:8]), .Ci(C2), .S(S[11:8]), .GG(G2), .PP(P2));
 CLA_4 U3(.A(A[15:12]), .B(B[15:12]), .Ci(C3), .S(S[15:12]), .GG(G3), .PP(P3));
 CLA_4 U4(.A(A[19:16]), .B(B[19:16]), .Ci(C4), .S(S[19:16]), .GG(G4), .PP(P4));
 CLA_4 U5(.A(A[23:20]), .B(B[23:20]), .Ci(C5), .S(S[23:20]), .GG(G5), .PP(P5));
 CLA_4 U73(.A(A[27:24]), .B(B[27:24]), .Ci(C6), .S(S[27:24]), .GG(G6), .PP(P6));
 CLA_4 U74(.A(A[31:28]), .B(B[31:28]), .Ci(C7), .S(S[31:28]), .GG(G7), .PP(P7));
 //and (Co, 1'b1, S[23]);
 //Generation
 
 //C1=G0+P0Cin
 and 	U6(temp[0], P0, Cin);
 or	U7(C1, temp[0], G0);
 //C2=G1+P1G0+P1P0Cin
 and	U8(temp[1], P1, P0, Cin);
 and	U9(temp[2], P1, G0);
 or	U10(C2, G1, temp[1], temp[2]);
 //C3=G2+P2G1+P2P1G0+P2P1P0Cin
 and	U11(temp[3], P2, G1);
 and	U12(temp[4], P2, P1, G0);
 and	U13(temp[5], P2, P1, P0);
 and	U14(temp[6], temp[5], Cin);
 or	U15(temp[7], G2, temp[3], temp[4]);
 or	U16(C3, temp[7], temp[6]);
 //C4=G3+P3G2+P3P2G1+P3P2P1G0+P3P2P1P0Cin
 and	U17(temp[8], P3, G2); //P3G2-
 and	U18(temp[9], P3, P2, G1); //P3P2G1-
 and	U19(temp[10], P3, P2, P1); //P3P2P1
 and	U20(temp[11], temp[10], G0); //P3P2P1G0-
 and	U21(temp[12], temp[10], P0, Cin);//P3P2P1P0Cin-
 
 or 	U22(temp[13], G3, temp[8], temp[9]); //G3+P3G2+P3P2G1-
 or	U23(C4, temp[13], temp[11], temp[12]); //G3+P3G2+P3P2G1+P3P2P1G0+P3P2P1P0Cin
 //C5=G4+P4G3+P4P3G2+P4P3P2G1+P4P3P2P1G0+P4P3P2P1P0Cin
 and	U24(temp[15], P4, G3); //P4G3
 and	U25(temp[16], P4, P3, G2); //P4P3G2;
 and	U26(temp[17], P4, P3, P2); //P4P3P2;
 and	U27(temp[18], temp[17], G1); //P4P3P2G1
 and	U28(temp[19], temp[17], P1, G0); //P4P3P2P1G0
 and	U29(temp[20], temp[17], P1, P0); //P4P3P2P1P0
 and	U30(temp[21], temp[20], Cin); //P4P3P2P1P0Cin
 
 or	U31(temp[22], G4, temp[15], temp[16]); //G4+P4G3+P4P3G2
 or	U32(temp[23], temp[22], temp[18], temp[19]);//G4+P4G3+P4P3G2+P4P3P2G1+P4P3P2P1G0
 or	U33(C5, temp[23], temp[21]); //G4+P4G3+P4P3G2+P4P3P2G1+P4P3P2P1G0+P4P3P2P1P0Cin
 //C6=G5+P5G4+P5P4G3+P5P4P3G2+P5P4P3P2G1+P5P4P3P2P1G0+P5P4P3P2P1P0Cin
 and	U34(temp[24], P5, G4);//P5G4
 and	U35(temp[25], P5, P4, G3);//P5P4G3
 and	U36(temp[26], P5,P4, P3);//P5P4P3
 and	U37(temp[27], temp[26], G2); //P5P4P3G2
 and	U38(temp[28], temp[26], P2, G1);//P5P4P3P2G1
 and	U39(temp[29], temp[26], P2, P1); //P5P4P3P2P1;
 and	U40(temp[30], temp[29], G0); //P5P4P3P2P1G0;
 and	U41(temp[31], temp[29], P0, Cin); //P5P4P3P2P1P0Cin
 
 or	U42(temp[32], G5, temp[24], temp[25]);//G5+P5G4+P5P4G3
 or	U43(temp[33], temp[32], temp[27], temp[28]);//G5+P5G4+P5P4G3+P5P4P3G2+P5P4P3P2G1
 or	U44(C6, temp[33], temp[30], temp[31]);
 
  //C7=G6+P6G5+P6P5G4+P6P5P4G3+P6P5P4P3G2+P6P5P4P3P2G1+P6P5P4P3P2P1G0+P6P5P4P3P2P1P0Cin
 and	U45(temp[34], P6, G5);//P6G5
 and	U46(temp[35], P6, P5, G4);		 //P6P5G4
 and	U47(temp[36], P6, P5, P4);		 //P6P5P4
 and	U48(temp[37], temp[36], G3); 	 //P6P5P4G3
 and	U49(temp[38], temp[36], P3, G2); //P6P5P4P3G2
 and	U50(temp[39], temp[36], P3, P2); //P6P5P4P3P2;
 and	U51(temp[40], temp[39], G1); 	 //P6P5P4P3P2G1;
 and	U52(temp[41], temp[39], P1, G0); //P6P5P4P3P2P1G0;
 and	U53(temp[42], temp[41], P0, Cin);//P6P5P4P3P2P1P0Cin
 
 or	U54(temp[43], G6, temp[34], temp[35]);//G6+P6G5+P6P5G4
 or	U55(temp[44], temp[43], temp[37], temp[38]);//G6+P6G5+P6P5G4+P6P5P4G3+P6P5P4P3G2
 or	U56(temp[45], temp[44], temp[40], temp[41]); //G6+P6G5+P6P5G4+P6P5P4G3+P6P5P4P3G2+P6P5P4P3P2G1+P6P5P4P3P2P1G0
 or	U57(C7, temp[45], temp[42]); 
 
//Co =  G7+P7G6+P7P6G5+P7P6P5G4+P7P6P5P4G3+P7P6P5P4P3G2
   //    +P7P6P5P4P3P2G1+P7P6P5P4P3P2P1G0+P7P6P5P4P3P2P1P0Cin
 and	U58(temp[46], P7, G6);//P7G6
 and	U59(temp[47], P7, P6, G5);		 //P7P6G5
 and	U60(temp[48], P7, P6, P5);		 //P7P6P5
 and	U61(temp[49], temp[48], G4); 	 //P7P6P5G4
 and	U62(temp[50], temp[48], P4, G3); //P7P6P5P4G3
 and	U63(temp[51], temp[48], P4, P3); //P7P6P5P4P3;
 and	U64(temp[52], temp[51], G2); 	 //P7P6P5P4P3G2;
 and	U65(temp[53], temp[51], P2, G1); //P7P6P5P4P3P2G1;
 and	U66(temp[54], temp[51], P2, P1); //P7P6P5P4P3P2P1;
 and	U67(temp[55], temp[54], G0);	 //P7P6P5P4P3P2P1G0;
 and	U68(temp[59], temp[54], P0, Cin); //P7P6P5P4P3P2P1P0Cin
 
 or	U69(temp[56], G7, temp[46], temp[47]);//G7+P7G6+P7P6G5
 or	U70(temp[57], temp[56], temp[49], temp[50]);// G7+P7G6+P7P6G5+P7P6P5G4+P7P6P5P4G3
 or	U71(temp[58], temp[57], temp[52], temp[53]);// tem[57] + P7P6P5P4P3G2+P7P6P5P4P3P2G1


 or	U72(Co, temp[58], temp[55],temp[59]); 
 endmodule
 
 
 
 


