module branch_comp(in1,in2,BrUn,BrEq,BrLt);
input [31:0] in1,
             in2;

input BrUn;
output BrEq;
output BrLt;
compare inst_compare (  
 .A(in1),  
 .B(in2), 
 .BrUn(BrUn), 
 .BrEq(BrEq), 
  .BrLT(BrLt)
  );
endmodule
