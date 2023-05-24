module clockDivider # (parameter divisor = 28'd2)
							(input clk_in, output logic clk_out);
	
	logic [27:0] counter = 28'd0;
	logic clk_out_aux;
	always_ff @(posedge clk_in) begin
	
			counter <= counter + 28'd1;
			if (counter >= (divisor-1)) counter <= 28'd0;
			clk_out_aux <= (counter < divisor/2) ? 1'b1 : 1'b0;
		
		
	end	
	assign clk_out = clk_out_aux;

endmodule