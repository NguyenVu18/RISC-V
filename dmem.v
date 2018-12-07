module dmem(clk,rst_, addr, wdata, rdata, memrw);
parameter N = 32;
parameter DELAY_MEM = 200;
input clk;
input rst_;
input [N-1:0] addr;
input [N-1:0] wdata;
input memrw;


output [N-1:0] rdata;
//reg [N-1:0] rdata;

reg [7:0] mem [0:1024-1];
reg [N:0] i;

wire [N-1:0] internal_addr;
assign internal_addr = {addr[N-1:2], 2'b0}; // data 4 byte
assign rdata = {mem[internal_addr+3],mem[internal_addr+2],mem[internal_addr+1],mem[internal_addr]};
always @(posedge clk or negedge rst_)
begin
/*	if(!rst_) 
		begin
			    for (i = 0; i < 1024 ; i = i + 1)
				begin
					mem[i] = 8'b00000000;
				end
		end
	else */
		begin
			if (memrw == 1'b1) 
				begin

				  mem[internal_addr+3] <= #10 wdata[31:24];
					mem[internal_addr+2] <= #10 wdata[23:16];
					mem[internal_addr+1] <= #10 wdata[15:8];
					mem[internal_addr  ] <= #10 wdata[7:0];
					
				end
		/*	else
				begin
					rdata = {mem[internal_addr+3],mem[internal_addr+2],
							mem[internal_addr+1], mem[internal_addr]};
					
				end */
		end
end
initial begin
        for (i = 0; i < 1024 ; i = i + 1)
        begin
        mem[i] = 8'b00000000;
        end
        mem[0] = 8'd10;
        mem[4] = 8'd9;
        mem[8] = 8'd12;
        mem[12] = 8'd20;
        mem[16] = 8'd11;
        mem[20] = 8'd9;
        mem[24] = 8'd8;
        mem[28] = 8'd15;
        mem[32] = 8'd17;
        mem[36] = 8'd18;
end
endmodule
