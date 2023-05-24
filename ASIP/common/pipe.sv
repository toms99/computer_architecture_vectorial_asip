module pipe #(parameter WIDTH = 8)
			  ( input logic 	         clk, reset,
			    input logic  [WIDTH-1:0] in,
				output logic [WIDTH-1:0] out );

	always_ff @( posedge clk, posedge reset )
	begin
		if (reset) 	    out <= 0;
		else begin 
			out<= in;
		end		
	end
endmodule