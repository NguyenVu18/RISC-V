////////////////////////////////////////////////////////////////////////////////
//
// Arrive Technologies
//
// Filename     : datapath.v
// Description  : .
//
// Author       : Dang Nguyen@DESKTOP-VH2B9EI
// Created On   : Sun Nov 11 20:55:30 2018
// History (Date, Changed By)
//
////////////////////////////////////////////////////////////////////////////////

module datapath
    (
     clk,
     rst_,
     ena_pc,
     pcsel,
     immsel,
     regwen,
     brun,
     bsel,
     asel,
     alusel,
     memrw,
     wbsel,
    // mem_store,
    // mem_load,

     inst,
     breq,
     brlt,
     alu_comp
     );

////////////////////////////////////////////////////////////////////////////////
// Parameter declarations
parameter INST_WIDTH = 32;
parameter OPCODE_WIDTH = 5;

////////////////////////////////////////////////////////////////////////////////
// Port declarations
input clk,
      rst_,
      ena_pc;

input  pcsel,
       brun,
       bsel, // noi vao mux bsel
       asel,
       memrw;
input  [1:0] regwen; // noi vao REG
input  [2:0] immsel; // noi vao imm gen
input  [1:0] wbsel;
input  [3:0] alusel;  // noi vao ALu
//input  [2:0] mem_load;
//input  [1:0] mem_store ;

output [INST_WIDTH-1:0] inst;
output brlt,
       breq;
output alu_comp;

////////////////////////////////////////////////////////////////////////////////
// Output declarations
wire [INST_WIDTH-1:0] inst;
wire brlt,
     breq;
wire alu_comp; // noi vao ALU
wire ena_pc;

////////////////////////////////////////////////////////////////////////////////
// Local logic and instantiation

wire [31:0] mux_pcsel;
wire [31:0] addr_current;
wire [INST_WIDTH-1:0] dataO_ALU;
assign                    mux_pcsel = pcsel ? dataO_ALU : (addr_current + 4 );
//wire [31:0] pcadd4;
//assign pcadd4 = addr_current + 4;
PC pc (
       .clk(clk),
       .ena_pc(ena_pc),
       .addr_load(mux_pcsel),
       .addr_current(addr_current) // dia chi PC hien thoi 
       );

imem imem_1 (
           .pc(addr_current),
           .inst(inst) // input vao bo control
           );



wire [31:0]               data_mem;
/*
dmem dmem (
           .clk(clk),
           .rst_(rst_),
           .addr(dataO_ALU),
           .wdata(DataB),
           .rdata(data_mem),
           .memrw(memrw)
           );  */

wire [31:0]               mux_WBSel;
assign                    mux_WBSel = (wbsel == {2'b00}) ? data_mem : ((wbsel == {2'b01} ) ?  dataO_ALU : (addr_current + 4));
wire [31:0]               DataA ;
wire [31:0]               DataB ;
wire [4:0]                AddrD;
wire [4:0]                AddrA;
wire [4:0]                AddrB;
assign                    AddrD = inst[11:7];
assign                    AddrA = inst[19:15];
assign                    AddrB = inst[24:20];
dmem dmem_1(
        .clk(clk),
        .rst_(rst_),
        .addr(dataO_ALU),
        .wdata(DataB),
        .rdata(data_mem),
        .memrw(memrw)
);

RegFile register (
                  .clk(clk),
                  .rst_(rst_),
                  .AddrA(AddrA),
                  .AddrB(AddrB),
                  .AddrD(AddrD),
                  .WEn(regwen),
                  .DataD(mux_WBSel),
                  .DataA(DataA),
                  .DataB(DataB)
                  );

branch_comp branchcomp (
                        .in1(DataA),
                        .in2(DataB),
                        .BrUn(brun),
                        .BrEq(breq),
                        .BrLt(brlt)
                        );

wire [31:0]               immgen_out ;

imm_gen immgen (
                .inst(inst),
                .imm_sel(immsel),
                .out(immgen_out)
                );

wire [31:0]               mux_bsel;
assign                    mux_bsel = bsel ? immgen_out : DataB;
wire [31:0]               mux_asel;
assign                    mux_asel = asel ? addr_current : DataA;


//wire [INST_WIDTH-1:0] dataA;
//wire [INST_WIDTH-1:0] dataB;

 

ALU alu (
         .dataA(mux_asel),
         .dataB(mux_bsel),
         .sel_ALU(alusel),
         .alu_comp(alu_comp),
         .dataO(dataO_ALU)
         );

endmodule 
