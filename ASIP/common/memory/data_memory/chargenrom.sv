module chargenrom( input logic [9:0] x, y, input logic inrect, clk, start, output logic [7:0] pixel);

		logic [7:0] charrom[9999:0];
		
		always @(posedge clk or posedge start) begin
			if (start) begin
				$readmemb("RAM.txt", charrom);
			end
		end
		
		assign pixel = inrect ? charrom[100*x + y] : 7'h00;
		
endmodule