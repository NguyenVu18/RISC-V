module top(clk,ena_pc,rst_);
input clk;
input ena_pc;
input rst_;
wire pcsel;
wire brun;
wire brlt;
wire breq;
wire asel;
wire bsel;
wire memrw;
wire  alu_comp;
wire  [1:0] wbsel;
wire  [1:0] regwen;
wire  [2:0] immsel;
wire  [3:0] alusel;
wire  [31:0] inst;

datapath datapath_1(
        .rst_(rst_),
        .clk(clk),
        .ena_pc(ena_pc),
        .pcsel(pcsel),
        .brun(brun),
        .brlt(brlt),
        .breq(breq),
        .asel(asel),
        .bsel(bsel),
        .memrw(memrw),
        .alu_comp(alu_comp),
        .wbsel(wbsel),
        .regwen(regwen),
        .immsel(immsel),
        .alusel(alusel),
        .inst(inst)
);

top_control control(
          .clk(clk),
          .rst_(rst_),
          .pcsel(pcsel),
          .brun(brun),
          .brlt(brlt),
          .breq(breq),
          .asel(asel),
          .bsel(bsel),
          .memrw(memrw),
          .alu_comp(alu_comp),
          .wbsel(wbsel),
          .regwen(regwen),
          .immsel(immsel),
          .alusel(alusel),
          .inst(inst)
);
endmodule
