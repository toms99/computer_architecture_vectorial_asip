// FALTA AGREGARLE PCWriteEn, ExecuteOP 
// y los parametros de salida de los registros vectoriales *******************************
module decoderStage(
							input clk, input reset,
							input [15:0] instruction,
							output MemoryWrite,
						   output [1:0] WriteRegFrom,
							output [3:0] RegToWrite,
							output [7:0] Immediate,
							output RegWriteEn);
							);
	
	Decoder decoder(instruction, MemoryWrite, WriteRegFrom, RegToWrite, Immediate, RegWriteEn);
	
	// FALTA Agregar registros*******************************

endmodule	