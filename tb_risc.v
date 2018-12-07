module t_alu;

reg t_clk;
reg t_rst_;
reg t_ena_pc;


//Generate clk
always begin
        t_clk = 0;
    #50 t_clk = 1;
    #50;
end

//Instance module 
top top_01 ( .clk(t_clk),
             .ena_pc(t_ena_pc),
             .rst_(t_rst_)
           );
always@(negedge top_01.clk) begin
if (top_01.ena_pc && ($time > 300)) begin	
    $display("",$time) ;
end
end
always@(negedge top_01.clk) begin
   if(top_01.inst == 32'b0 && $time>500) begin
    t_ena_pc <= 1'b0;
          end 
end

initial begin
#0   t_rst_ = 0;
#0     t_ena_pc = 0;
#100 t_rst_ = 1;
#100  t_ena_pc = 1;

//#8000  t_ena_pc = 0;

end
initial begin
        $vcdplusfile ("alu.vpd");
        $vcdpluson();
end
endmodule
