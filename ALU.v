/*
parameter ALU_IN2 = 4'b0000; // ALUSEL out dataB
parameter ALU_ADD = 4'b0001;
parameter ALU_SUB = 4'b0010;
parameter ALU_AND = 4'b0011;
parameter ALU_OR = 4'b0100;
parameter ALU_XOR = 4'b0101;
parameter ALU_SHL = 4'b0110;   shift : use dataB
parameter ALU_SHRL = 4'b0111;
parameter ALU_SHRA = 4'b1000;
parameter ALU_COMPU = 4'b1001; // compare unsign 
parameter ALU_COMPS = 4'b1010; // compare sign 
*/
// when use compare , ignore dataO
module ALU (dataA, dataB, sel_ALU ,dataO ,alu_comp);
input [31:0] dataA;
input [31:0] dataB;
input [3:0] sel_ALU;
wire [5:0] num_shift;
assign num_shift = dataB [5:0];
//output BrEq;
//output BrLT;
output [31:0] dataO;
output alu_comp;
reg [31:0] dataO;
reg alu_comp;
wire [31:0] and_data;
wire [31:0] or_data;
wire [31:0] xor_data;
// signal shift 
wire [31:0] oshift;
// signal CLA_32
wire [31:0] oadd_sub;
wire [31:0] addsub_dataB;
wire cin;
wire co;
// shift
wire [31:0] shift_left;
wire [31:0] shift_rightl;
wire [31:0] shift_righta;
// compare
//wire BrUn;
assign and_data = dataA & dataB;
assign or_data = dataA | dataB;
assign xor_data = dataA ^ dataB;
assign shift_left = dataA << num_shift;
assign shift_rightl = dataA >> num_shift;
assign shift_righta = dataA >>> num_shift;


assign cin = (sel_ALU == 4'b0010)? 1 : 0;
assign addsub_dataB = (sel_ALU == 4'b0010) ? (~dataB): dataB;
add32bit  inst_addsub(
				.a(dataA), 
				.b(addsub_dataB), 
				.cin(cin), 
				.out(oadd_sub), 
				.cout(co)
			);
/*assign BrUn = (sel_ALU == 4'b1001);
compare inst_compare ( 	
						.A(dataA), 
						.B(dataB) , 
						.BrUn(BrUn), 
						.BrEq(BrEq), 
						.BrLT(BrLT)
					); */

always @(*)
	begin
		case (sel_ALU)
		4'b0000: dataO = dataB;
		4'b0001: dataO = oadd_sub;
		4'b0010: dataO = oadd_sub;
		4'b0011: dataO = and_data;
		4'b0100: dataO = or_data;
		4'b0101: dataO = xor_data;
		4'b0110: dataO = shift_left;
		4'b0111: dataO = shift_rightl;
		4'b1000: dataO = shift_righta;
    4'b1001: begin 
             alu_comp = (dataA < dataB)? 1:0;
             dataO = 32'b0;
             end 
    4'b1010: begin
             alu_comp = ($signed(dataA) < $signed(dataB))? 1:0 ;
             dataO = 32'b0;
             end
		default : dataO = 32'b0;
		endcase
	end
endmodule
