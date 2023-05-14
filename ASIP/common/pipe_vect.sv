module pipe_vect #(parameter WIDTH = 8,
				  parameter registerSize = 8,
				  parameter vectorSize = 4)
			  ( input logic 	         clk, reset,
			    input logic  [WIDTH-1:0] in,
				 input logic [vectorSize-1:0] [registerSize-1:0] vect1, vect2,
				output logic [WIDTH-1:0] out
				output logic [vectorSize-1:0] [registerSize-1:0] vect1_out, vect2_out);

	always_ff @( posedge clk, posedge reset )
	begin
		if (reset) 	 begin
			out <= 0;
			vect1_out <=0;
			vect2_out <=0;
		end
		else begin 
			out<= in;
			vect1_out <=vect1;
			vect2_out <=vect2;
		end		
	end
endmodule