module tb_processor();

    logic clk, reset;
    logic mode_xor, mode_rshift, mode_lshift, mode_ecae, mode_dcae;
    logic mode_mul;

	processor dut(clk, reset, mode_xor, mode_rshift,
        mode_lshift, mode_ecae, mode_dcae, mode_mul);
	 

    always #5 clk = ~clk;
    initial begin
        clk = 0;
        mode_xor = 0;
        mode_rshift = 0;
        mode_lshift = 0;
        mode_ecae = 0;
        mode_dcae = 0;
        mode_mul = 0;
        reset = 1; # 10 ;
		reset = 0;
        #10;
        mode_xor = 1;

        
    end

endmodule