module imm_gen(inst,imm_sel,out);
input [31:0] inst;
input [2:0] imm_sel;
output [31:0] out;
reg [31:0] out ;
always@(*)
begin
        case (imm_sel)
                3'b000: out = 32'b0;
                3'b011: out = {{21{inst[31]}},inst[30:20]};//I_imm
                3'b101: out = {inst[31:12],{12{1'b0}}}; // U_imm
                3'b001: out = {{12{inst[31]}},inst[19:12],inst[20],inst[30:21],1'b0}; //J
                3'b010: out = {{20{inst[31]}},inst[7],inst[30:25],inst[11:8],1'b0};//B
                3'b100: out = {{21{inst[31]}},inst[30:25],inst[11:7]}; // S
                3'b111: out = {{26{1'b0}},inst[25:20]}; // shamount
        endcase
end
endmodule
