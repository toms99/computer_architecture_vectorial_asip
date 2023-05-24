module chargenrom( input logic [9:0] x, y, input logic inrect, output logic [7:0] pixel);

		logic [7:0] charrom[9999:0]; // character generator ROM

		// Initialize ROM with characters from text file
		initial
		$readmemb("RAM.txt", charrom);
		

		// is entry 0
		// Reverse order of bits
		assign pixel = inrect ? charrom[100*x + y] : 7'h00;
		
endmodule