module chargenrom( input logic [9:0] x, y, input logic inrect, clk, start, output logic [7:0] pixel);

		logic [7:0] charrom[9999:0];
		logic [7:0] img2[9999:0];
		logic [7:0] temp[9999:0];
		initial begin
			$readmemb("RAM.txt", charrom);
			$readmemb("RAM2.txt", img2);
		end
		always @(posedge clk) begin
			if (start) begin
				temp <= charrom;
			end
			else begin
				temp <= img2;
			end
		end
		
		assign pixel = inrect ? temp[100*x + y] : 7'h00;
		
endmodule