////////////////////////////////////////////////////////////////////////////////
//
// Arrive Technologies
//
// Filename     : top_control.v
// Description  : .
//
// Author       : Dang Nguyen@DESKTOP-VH2B9EI
// Created On   : Tue Oct 30 21:12:29 2018
// History (Date, Changed By)
//
////////////////////////////////////////////////////////////////////////////////

module top_control
    (
     clk,
     rst_,
     inst,
     brlt,
     breq,
     alu_comp, // compare alu  1: LT Rs < imm , 0: not LT Rs > = imm 

     pcsel,
     immsel,
     regwen,
     brun,
     bsel,
     asel,
     alusel,
     memrw,
     wbsel,
     mem_store,
     mem_load
      );

////////////////////////////////////////////////////////////////////////////////
// Parameter declarations
parameter INST_WIDTH = 32;
parameter OPCODE_WIDTH = 5;

parameter PC_4 = 1'b0 ; // PCsel
parameter ALU = 1'b1 ;

parameter EN_REGW = 2'b11; // regwen
parameter DIS_REGW = 2'b00;
parameter DIS_REGW_D_1 = 2'b01;
parameter DIS_REGW_D_0 = 2'b10;


parameter BR_UNSIGN = 1'b1 ; // brun
parameter BR_SIGN = 1'b0 ;

parameter BSEL_IMM = 1'b1; // bsel
parameter BSEL_RS2 = 1'b0;

parameter ASEL_PC = 1'b1;   // asel
parameter ASEL_RS1 = 1'b0;

parameter MEM_WR = 1'b1; // MEMRW
parameter MEM_RD = 1'b0;

parameter DISABLE_IMM = 3'b000; //IMMSEL
parameter J_IMM = 3'b001;
parameter B_IMM = 3'b010;
parameter I_IMM = 3'b011;
parameter S_IMM = 3'b100;
parameter U_IMM = 3'b101;
parameter SHAMT = 3'b111;


parameter WBSEL_DMEM = 2'b00; // WBSEL
parameter WBSEL_ALU = 2'b01;
parameter WBSEL_PC4 = 2'b10;

parameter ALU_IN2 = 4'b0000; // ALUSEL
parameter ALU_ADD = 4'b0001;
parameter ALU_SUB = 4'b0010;
parameter ALU_AND = 4'b0011;
parameter ALU_OR = 4'b0100;
parameter ALU_XOR = 4'b0101;
parameter ALU_SHL = 4'b0110;
parameter ALU_SHRL = 4'b0111;
parameter ALU_SHRA = 4'b1000;
parameter ALU_COMPU = 4'b1001; // compare unsign 
parameter ALU_COMPS = 4'b1010; // compare sign 


parameter MEM_LB = 3'b000; // MEM_LOAD
parameter MEM_LH = 3'b001;
parameter MEM_LW = 3'b010;
parameter MEM_LBU = 3'b100;
parameter MEM_LHU = 3'b101;

parameter MEM_SB = 2'b00;  // MEM_STORE
parameter MEM_SH = 2'b01;
parameter MEM_SW = 2'b10;



















////////////////////////////////////////////////////////////////////////////////
// Port declarations
input clk,rst_ ;
input [INST_WIDTH-1:0] inst;
input brlt,
      breq;
input alu_comp;


output pcsel,
       brun,
       bsel,
       asel,
       memrw;
output [1:0] regwen;
output [2:0] immsel;
output [1:0] wbsel;
output [3:0] alusel;
output [2:0] mem_load;
output [1:0] mem_store ;


             
////////////////////////////////////////////////////////////////////////////////
// Output declarations
wire    pcsel,
        brun,
        bsel,
        asel,
        memrw;
wire [1:0] regwen;
wire    [2:0] immsel;
wire    [1:0] wbsel;
wire [3:0]    alusel;

wire [2:0]    mem_load;
wire [1:0]    mem_store;


////////////////////////////////////////////////////////////////////////////////
// Local logic and instantiation
reg     pcsel_r, // 0: PC+4 , 1: ALU 
        brun_r, // 1: unsign , 0: sign 
        bsel_r, // 1 : imm , 0 : rs2
        asel_r, // 1: PC , 0: rs1 
        memrw_r; // 1: wirte , 0: read
reg [1:0] regwen_r;
reg [2:0] immsel_r;// 000: disable_imm , 001 : j_imm , 010: b_imm , 011: i_imm
                    // 100 : s_imm , 101 : u_imm 
reg [1:0] wbsel_r; // 00 : d_mem , 01 : alu , 10 : PC+4
reg [3:0]     alusel_r; // 0000: in2 , 0001 : add , 0010 : sub  , 0011 , and ,
                        // 0100 : or , 0101 : xor , 0110 : shift_left 
                        // 0111 : shift_right , 1000 : compare 
reg [2:0]     mem_load_r ; // 000 : LB , 001 : LH , 010 : LW , 100 : LBU , 101 : LHU 
reg [1:0]     mem_store_r; // 00 : SB , 01 : SH , 10 : SW

wire [OPCODE_WIDTH-1:0] opcode; // opcode inst
assign                  opcode = inst[6:2];
wire [2:0]              funct; // function
assign                  funct = inst [14:12];

always @(inst or negedge rst_)
    begin
    if(!rst_)
        begin
        pcsel_r <= 1'b0;
        regwen_r <= DIS_REGW;
        brun_r <= 1'b0 ;       
        bsel_r <= 1'b0;        
        asel_r <= 1'b0;        
        memrw_r <= 1'b0;
        immsel_r <= 3'b000;
        wbsel_r <= 2'b00 ;
        alusel_r <= 4'b0000;
        end
        else begin
             case (opcode)
            5'b01101 : //LUI
                begin
                pcsel_r <= PC_4;
                regwen_r <= EN_REGW;
                immsel_r <= U_IMM;//u_imm
                bsel_r <= BSEL_IMM;
                alusel_r <= ALU_IN2;
                memrw_r <= MEM_RD;
                wbsel_r <= WBSEL_ALU;             
                end
            5'b00101 : // AUIPC
                begin
                pcsel_r <= PC_4;
                regwen_r <= EN_REGW;
                immsel_r <= U_IMM;//u_imm
                asel_r <= ASEL_PC;
                bsel_r <= BSEL_IMM;
                alusel_r <= ALU_ADD;
                memrw_r <= MEM_RD;
                wbsel_r <= WBSEL_ALU; 
                end
            5'b11011: // JAL
                begin
                pcsel_r <= ALU;
                regwen_r <= EN_REGW;
                immsel_r <= J_IMM;//j_imm
                asel_r <= ASEL_PC;
                bsel_r <= BSEL_IMM;
                alusel_r <= ALU_ADD;
                memrw_r <= MEM_RD;
                wbsel_r <= WBSEL_PC4;
                end
            5'b11001 : // JALR
                begin
                pcsel_r <= ALU;
                regwen_r <= EN_REGW;
                immsel_r <= I_IMM;//j_imm
                asel_r <= ASEL_RS1;
                bsel_r <= BSEL_IMM;
                alusel_r <= ALU_ADD;
                memrw_r <= MEM_RD;
                wbsel_r <= WBSEL_PC4;
                end
            5'b11000 :
                begin
                case(funct)
                    3'b000:
                        begin
                        brun_r <= BR_SIGN ; // sign
                        regwen_r <= DIS_REGW;                        
                        immsel_r <= B_IMM;//b_imm
                        asel_r <=ASEL_PC ;
                        bsel_r <= BSEL_IMM;
                        alusel_r <= ALU_ADD;
                        memrw_r <= MEM_RD;
                        #10 pcsel_r <= (breq==1) ? 1'b1 : 1'b0 ;
                        end
                    3'b001:
                        begin
                        brun_r <= BR_SIGN; // sign
                        regwen_r <= DIS_REGW;                        
                        immsel_r <= B_IMM;//b_imm
                        asel_r <= ASEL_PC;
                        bsel_r <= BSEL_IMM;
                        alusel_r <= ALU_ADD;
                        memrw_r <= MEM_RD;
                        #10 pcsel_r <=  breq ? PC_4 : ALU ;
                        end
                    3'b100 :
                        begin
                        brun_r <= BR_SIGN ; // sign
                        regwen_r <= DIS_REGW;                        
                        immsel_r <= B_IMM;//b_imm
                        asel_r <= ASEL_PC;
                        bsel_r <= BSEL_IMM;
                        alusel_r <= ALU_ADD;
                        memrw_r <= MEM_RD;
                        #10 pcsel_r <= brlt ? ALU : PC_4 ;
                        end
                    3'b101 :
                        begin
                        brun_r <= BR_SIGN; // sign
                        regwen_r <= DIS_REGW;                        
                        immsel_r <= B_IMM;//b_imm
                        asel_r <= ASEL_PC;
                        bsel_r <= BSEL_IMM;
                        alusel_r <= ALU_ADD;
                        memrw_r <= MEM_RD;
                        #10 pcsel_r <= brlt ? PC_4 : ALU ;
                        end
                    3'b110 :
                        begin
                        brun_r <= BR_UNSIGN ; // un_sign
                        regwen_r <= DIS_REGW;                        
                        immsel_r <= B_IMM;//b_imm
                        asel_r <= ASEL_PC;
                        bsel_r <= BSEL_IMM;
                        alusel_r <= ALU_ADD;
                        memrw_r <= MEM_RD;
                        #10 pcsel_r <= brlt ? ALU : PC_4 ;
                        end
                    default :
                        begin
                        brun_r <= BR_UNSIGN ; //un_ sign                       
                        regwen_r <= DIS_REGW;                        
                        immsel_r <= B_IMM;//b_imm
                        asel_r <= ASEL_PC;
                        bsel_r <= BSEL_IMM;
                        alusel_r <= ALU_ADD;
                        memrw_r <= MEM_RD;
                        #10 pcsel_r <= brlt ? PC_4 : ALU ;
                        end
                endcase
                end
            5'b00000 :
                begin
                pcsel_r <= PC_4;                       
                regwen_r <= EN_REGW;                        
                immsel_r <= I_IMM;//i_imm
                asel_r <= ASEL_RS1;
                bsel_r <= BSEL_IMM;
                alusel_r <= ALU_ADD;
                memrw_r <= MEM_RD;
                case(funct) 
                    3'b000: mem_load_r <= MEM_LB; // LB
                    3'b001: mem_load_r <= MEM_LH; // LH
                    3'b010: mem_load_r <= MEM_LW; // LW
                    3'b100: mem_load_r <= MEM_LBU; // LBU
                    3'b101: mem_load_r <= MEM_LHU; // LHU  
                endcase
                end
            5'b01000 :
                begin
                pcsel_r <= PC_4;                       
                regwen_r <= DIS_REGW;                        
                immsel_r <= S_IMM;//s_imm
                asel_r <= ASEL_RS1;
                bsel_r <= BSEL_IMM;
                alusel_r <= ALU_ADD;
                memrw_r <= MEM_WR;
                wbsel_r <= WBSEL_DMEM;
                case(funct)
                    3'b000: mem_store_r <= MEM_SB; // SB
                    3'b001: mem_store_r <= MEM_SH; // SH
                    3'b010: mem_store_r <= MEM_SW; // SW
                endcase
                end
            5'b00100 :
                begin
                case(funct)
                    3'b000 : //ADDI
                        begin
                        pcsel_r <= PC_4;                       
                        regwen_r <= EN_REGW;                        
                        immsel_r <= I_IMM;
                        asel_r <= ASEL_RS1;
                        bsel_r <= BSEL_IMM;
                        alusel_r <= ALU_ADD;
                        memrw_r <= MEM_RD;
                        wbsel_r <= WBSEL_ALU;
                        end
                    3'b010 : //SLTI
                        begin
                        pcsel_r <= PC_4;                       
                        immsel_r <= I_IMM;
                        asel_r <= ASEL_RS1;
                        bsel_r <= BSEL_IMM;
                        alusel_r <= ALU_COMPS;
                        memrw_r <= MEM_RD;
                        #5 regwen_r <= alu_comp ? DIS_REGW_D_1 : DIS_REGW_D_0 ;
                        end
                    3'b011 : // SLTIU
                        begin
                        pcsel_r <= PC_4;                       
                        immsel_r <= I_IMM;
                        asel_r <= ASEL_RS1;
                        bsel_r <= BSEL_IMM;
                        alusel_r <= ALU_COMPU;
                        memrw_r <= MEM_RD;
                        #5 regwen_r <= alu_comp ? DIS_REGW_D_1 : DIS_REGW_D_0 ;
                        end
                    3'b100 :// XORI
                        begin
                        pcsel_r <= PC_4;                       
                        regwen_r <= EN_REGW;                        
                        immsel_r <= I_IMM;
                        asel_r <= ASEL_RS1;
                        bsel_r <= BSEL_IMM;
                        alusel_r <= ALU_XOR;
                        memrw_r <= MEM_RD;
                        wbsel_r <= WBSEL_ALU;
                        end
                    3'b110 :
                        begin
                        pcsel_r <= PC_4;                       
                        regwen_r <= EN_REGW;                        
                        immsel_r <= I_IMM;
                        asel_r <= ASEL_RS1;
                        bsel_r <= BSEL_IMM;
                        alusel_r <= ALU_OR;
                        memrw_r <= MEM_RD;
                        wbsel_r <= WBSEL_ALU;
                        end
                    3'b111 : // AND
                        begin
                        pcsel_r <= PC_4;                       
                        regwen_r <= EN_REGW;                        
                        immsel_r <= I_IMM;
                        asel_r <= ASEL_RS1;
                        bsel_r <= BSEL_IMM;
                        alusel_r <= ALU_AND;
                        memrw_r <= MEM_RD;
                        wbsel_r <= WBSEL_ALU;
                        end
                    3'b001 : //SLLI
                        begin
                        pcsel_r <= PC_4;                       
                        regwen_r <= EN_REGW;                        
                        immsel_r <= SHAMT;
                        asel_r <= ASEL_RS1;
                        bsel_r <= BSEL_IMM;
                        alusel_r <= ALU_SHL;
                        memrw_r <= MEM_RD;
                        wbsel_r <= WBSEL_ALU;
                        end
                   default : // SRLI & SRAI
                       begin
                       pcsel_r <= PC_4;                       
                       regwen_r <= EN_REGW;                        
                       immsel_r <= I_IMM;
                       asel_r <= ASEL_RS1;
                       bsel_r <= BSEL_IMM;
                       alusel_r <= inst[30] ? ALU_SHRA : ALU_SHRL;
                       memrw_r <= MEM_RD;
                       wbsel_r <= WBSEL_ALU;
                       end
                endcase 
                end
            5'b01100:
                begin
                case(funct)   
                    3'b000:  //ADD & SUB
                        begin
                        pcsel_r <= PC_4;                       
                        regwen_r <= EN_REGW;                        
                        asel_r <= ASEL_RS1;
                        bsel_r <= BSEL_RS2;
                        alusel_r <= inst[30] ? ALU_SUB : ALU_ADD ;
                        memrw_r <= MEM_RD;
                        wbsel_r <= WBSEL_ALU;
                        end
                    3'b001 : // SLL
                        begin
                        pcsel_r <= PC_4;                       
                        regwen_r <= EN_REGW;                        
                        asel_r <= ASEL_RS1;
                        bsel_r <= BSEL_RS2;
                        alusel_r <= ALU_SHL;
                        memrw_r <= MEM_RD;
                        wbsel_r <= WBSEL_ALU;
                        end
                    3'b010 : // SLT
                        begin
                        pcsel_r <= PC_4;                       
                        regwen_r <= alu_comp ? DIS_REGW_D_1 : DIS_REGW_D_0 ;              
                        asel_r <= ASEL_RS1;
                        bsel_r <= BSEL_RS2;
                        alusel_r <= ALU_COMPS;
                        memrw_r <= MEM_RD;
                        end
                    3'b011 : // SLTU
                        begin
                        pcsel_r <= PC_4;                       
                        regwen_r <= alu_comp ? DIS_REGW_D_1 : DIS_REGW_D_0 ;              
                        asel_r <= ASEL_RS1;
                        bsel_r <= BSEL_RS2;
                        alusel_r <= ALU_COMPU;
                        memrw_r <= MEM_RD;
                        end
                    3'b100 : //XOR
                        begin
                        pcsel_r <= PC_4;                       
                        regwen_r <= EN_REGW;                        
                        asel_r <= ASEL_RS1;
                        bsel_r <= BSEL_RS2;
                        alusel_r <= ALU_XOR;
                        memrw_r <= MEM_RD;
                        wbsel_r <= WBSEL_ALU;
                        end
                    3'b101 : // SRL & SRA
                        begin
                        pcsel_r <= PC_4;                       
                        regwen_r <= EN_REGW;                        
                        asel_r <= ASEL_RS1;
                        bsel_r <= BSEL_RS2;
                        alusel_r <= inst[30] ? ALU_SHRA : ALU_SHRL;
                        memrw_r <= MEM_RD;
                        wbsel_r <= WBSEL_ALU;
                        end
                    3'b110 : // OR
                        begin
                        pcsel_r <= PC_4;                       
                        regwen_r <= EN_REGW;                        
                        asel_r <= ASEL_RS1;
                        bsel_r <= BSEL_RS2;
                        alusel_r <= ALU_OR;
                        memrw_r <= MEM_RD;
                        wbsel_r <= WBSEL_ALU;
                        end
                    default : // AND
                        begin
                        pcsel_r <= PC_4;                       
                        regwen_r <= EN_REGW;                        
                        asel_r <= ASEL_RS1;
                        bsel_r <= BSEL_RS2;
                        alusel_r <= ALU_AND;
                        memrw_r <= MEM_RD;
                        wbsel_r <= WBSEL_ALU;
                        end
                endcase
                end
        endcase
        end
    end
assign pcsel = pcsel_r ;
assign regwen = regwen_r ;
assign brun = brun_r;
assign bsel = bsel_r;
assign asel = asel_r;
assign memrw = memrw_r;
assign immsel = immsel_r;
assign wbsel = wbsel_r;
assign alusel = alusel_r;
assign mem_load = mem_load_r;
assign mem_store = mem_store_r;

endmodule 
