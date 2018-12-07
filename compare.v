module compare ( A, B , BrUn, BrEq, BrLT);
input [31:0] A;
input [31:0] B;
input BrUn;
output BrEq;
output BrLT;


wire less_signed;
wire less_unsigned;
assign less_signed = ($signed(A) < $signed(B));
assign less_unsigned = A < B;

assign  BrLT = BrUn? (A < B):($signed(A) < $signed(B));//less than
assign  BrEq =  (A == B);//equal to

endmodule
