module videoGen(input logic [9:0] x, y, output logic [7:0] r, g, b);
		
		logic [7:0] pixel; 
		logic inrect;
		
		chargenrom chargenromb(y, x, inrect, pixel);
		rectgen rectgen(x, y, 10'd0, 10'd0, 10'd100, 10'd100, inrect);

		
		// assign {r, g} = pixel;
		assign r = pixel;
		assign g = pixel;
		assign b = pixel;

endmodule