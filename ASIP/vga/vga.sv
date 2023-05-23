module vga(input logic clk, output logic vgaclk, output logic hsync, vsync, output logic sync_b, blank_b, output logic [7:0] r, g, b);
		
		logic [9:0] x, y;
		
		clockDivider clkDiv(clk, vgaclk);
		
		// Generate monitor timing signals
		vgaController vgaCont(vgaclk, hsync, vsync, sync_b, blank_b, x, y);
		
		// User-defined module to determine pixel color
		videoGen videoGen(x, y, r, g, b);

endmodule