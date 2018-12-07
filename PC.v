module PC(clk,addr_load,addr_current,ena_pc,rst_);
input clk;
input ena_pc;
input rst_;
input [31:0] addr_load;
output wire [31:0] addr_current;
reg [31:0] addr;
assign addr_current = addr;
always@(posedge clk or negedge rst_)
begin
        if (!rst_)
        begin
        addr <= 10'b0;
        end
        else if (ena_pc) 
        begin 
        addr <= addr_load;
        end
        else begin 
                addr <= 10'b0;
             end
end
endmodule
