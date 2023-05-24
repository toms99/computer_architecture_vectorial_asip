module vga(
    input logic clk, input logic [7:0] vga_pixel,
    output logic [9:0] vga_adr,
    // VGA signals
    output logic vgaclk, output logic hsync, vsync,
    output logic sync_b, blank_b, output logic [7:0] r, g, b);
		
		logic [9:0] x, y;
		
		clockDivider clkDiv(clk, vgaclk);
		
		// Generate monitor timing signals
		vgaController vgaCont(vgaclk, hsync, vsync, sync_b, blank_b, x, y);
        assign vga_adr = 100*x + y;
        assign r = vga_pixel;
        assign g = vga_pixel;
        assign b = vga_pixel;
		
		// User-defined module to determine pixel color
		//videoGen videoGen(x, y, r, g, b);

endmodule