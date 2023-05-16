// FALTA AGREGARLE PCWriteEn, ExecuteOP 
// y los parametros de salida de los registros vectoriales *******************************
module decoderStage (
	input logic clk, reset,
	input logic [15:0] instruction,
	output logic MemoryWrite,
	output logic [2:0] ExecuteOp,
	output logic [1:0] WriteRegFrom,
	output logic OverwriteNZ,
	output logic [3:0] RegToWrite,
	output logic [7:0] Immediate,
	output logic RegWriteEnSc, 
	output logic RegWriteEnVec
);
	
	Decoder decoder_inst(instruction, MemoryWrite, ExecuteOp, WriteRegFrom, OverwriteNZ, RegToWrite, Immediate, RegWriteEnSc, RegWriteEnVec);
	

endmodule	