module tb_processor();

    logic clk, reset;

	 processor dut(clk, reset);
	 

    always #5 clk = ~clk;
    initial begin
        clk = 0;
        reset = 1; # 10 ;
		  reset = 0;

        
    end

endmodule