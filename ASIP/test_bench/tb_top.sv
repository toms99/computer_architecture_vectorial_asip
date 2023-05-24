module tb_top();
	logic clk;
	logic reset;
    logic vgaclk, hsync, vsync, sync_b, blank_b;
    logic [7:0] r, g, b;
	// instantiate device to be tested
	//Device under test
	top dut(clk, reset, vgaclk, hsync, vsync, sync_b, blank_b, r, g, b);
	// initialize test
	initial begin
		reset <= 1; #5; 
		reset <= 0;
	end
	// generate clock to sequence tests
	always begin
		clk <= 1; # 5; clk <= 0; # 5;
	end

endmodule