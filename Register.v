module RegFile(AddrA,DataA,AddrB,DataB,DataD,AddrD,WEn,clk,rst_);
input [3:0] AddrA,AddrB;               //Read
input [3:0] AddrD;                     //Write
input [1:0] WEn;
input clk,rst_;
input [31:0] DataD;                    
output [31:0] DataA,DataB;
reg [31:0] RF [0:15];                  //an array of 16 registers each of 32 bits
integer i;
assign DataA = RF[AddrA];
assign DataB = RF[AddrB];
always@(posedge clk or negedge  rst_)
begin
       // DataA <= RF[AddrA];
       // DataB <= RF[AddrB];
     //if (!rst_) 
     //begin
     //DataA <= 32'b0;
     //DataB <= 32'b0;
    // RF[0]= 32'b0000_0000_0000_0000_0000_0000_0000_0001;
    // RF[1]= 32'b0000_0000_0000_0000_0000_0000_0000_0010;
     //end
     
     if (WEn == 2'b11) 
     begin
     RF[AddrD] <= DataD;               //Write Data to AddrD
     end
     else #10 if(WEn == 2'b01)
     begin
     RF[AddrD] <= 32'd1;
     end
     else  if(WEn == 2'b10)
     begin 
     RF[AddrD] <= 32'd0;
     end
end

initial 
begin
                for(i=0;i<16;i=i+1)
                RF[i] = 0;
RF[1]=32'd0;
//RF[2]=32'd48;
end

endmodule
//Test
/*
module RegFile_tb;
// Inputs
reg [31:0] DataD;
reg [3:0] AddrA;
reg [3:0] AddrB;
reg [3:0] AddrD;
reg WRn;
reg rst;
reg clk;
// Outputs
wire [31:0] DataA;
wire [31:0] DataB;
// Instantiate the Unit Under Test (UUT)
RegFile UUT(.DataD(DataD),.AddrD(AddrD),.DataA(DataA),.AddrA(AddrA),.DataB(DataB),.AddrB(AddrB),.WRn(WRn),.rst(rst),.clk(clk));

initial
begin
//clk = 1'b1;
//rst = 1'b1;
//Initialize Inputs
DataD  = 32'b0;
AddrD  = 4'b0;
AddrA  = 4'b0;
AddrB  = 4'b0;
WRn  = 1'b0;
//#300 rst_  = 1'b0;

DataD  = 32'd123;
AddrD  = 4'h0;
AddrA  = 4'h1;
AddrB  = 4'h0;
WRn  = 1'b1;
//#50 rst  = 1'b0;  
//#300 rst  = 1'b1;

DataD  = 32'd456;
AddrD  = 4'h1;
AddrA  = 4'h0;
AddrB  = 4'h1;
WRn  = 1'b1;
//#50 rst  = 1'b0;  
//#300 rst  = 1'b1; 

DataD  = 32'd789;
AddrD  = 4'h1;
AddrA  = 4'h1;
AddrB  = 4'h1;
WRn  = 1'b1;
#50 rst  = 1'b0;  
#300 rst  = 1'b1;
end
always begin
#10 clk = ~clk;
end
endmodule
*/
