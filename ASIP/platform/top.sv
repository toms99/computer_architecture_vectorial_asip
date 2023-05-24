module top #(parameter N=8)(input clk, rst, start,
									 output logic vgaclk, 
									 output logic hsync, vsync, 
									 output logic sync_b, blank_b, 
									 output logic [7:0] r, g, b,
									 output logic fetchActive, regWrEnDe, regWrEnEx, regWrEnMem, regWrEnChip);
	
	processor proc(clk, rst, fetchActive, regWrEnDe, regWrEnEx, regWrEnMem, regWrEnChip);
	vga vga(clk, start, vgaclk, hsync, vsync, sync_b, blank_b,r, g, b);					
	
	
endmodule