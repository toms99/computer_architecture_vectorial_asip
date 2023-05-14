module stage_execute #(
	parameter registerSize = 8,
	parameter vectorSize = 4)
	(
	input logic clk, reset, ExecuteOp, PCWrEn,
	input logic [vectorSize-1:0] [registerSize-1:0] vect1, vect2,
	output logic [vectorSize-1:0] [registerSize-1:0] vect_out);
	

endmodule