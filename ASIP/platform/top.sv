module top #(parameter N=8)(input clk, rst,
									 output logic vgaclk, 
									 output logic hsync, vsync, 
									 output logic sync_b, blank_b, 
									 output logic [7:0] r, g, b);
	
	processor proc(clk, rst, vga_adr, vga_pixel);
	vga vga(clk, vga_pixel, vga_adr, vgaclk, hsync, vsync, sync_b, blank_b,r, g, b);					
	
	
endmodule