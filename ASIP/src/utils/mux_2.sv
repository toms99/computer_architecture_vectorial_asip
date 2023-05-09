module mux_2 #(parameter N=4)(input [N-1:0] a,
									  input [N-1:0] b,
									  input logic selector,
									  output [N-1:0] result);
			
	initial begin
		case (selector)
			0:  result = a;
			1:  result = b;
		endcase
	end
endmodule