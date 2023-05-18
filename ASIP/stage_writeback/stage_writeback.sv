module stage_writeback #(
    parameter vecSize = 4,
    parameter registerSize = 8
) (
   input clk, reset, writeEnable,
   input [1:0] writeRegFrom,
   input [registerSize-1:0] address, imm,
   input [vecSize-1:0] [registerSize-1:0] writeData, aluResult,
   output [vecSize-1:0] [registerSize-1:0] writeBackData
);
    
    logic [vecSize-1:0] [registerSize-1:0] readData, extended_imm;
    data_memory #(
        .dataSize(registerSize),
        .addressingSize(registerSize),
        .vecSize(vecSize)
    ) data_mem (
        .clk(clk),
        .write_enable(writeEnable), .DataAdr(address),
        .toWrite_data(writeData),
        .read_data(readData)
    );

    vector_extender #(
        .vectorSize(vecSize), .dataSize(registerSize)
    ) immExtender (
        .inData(imm), .outData(extended_imm)
    );
	  
	  logic [vecSize-1:0] [registerSize-1:0] writeBackDataTMP;
	 always_comb begin
		case (writeRegFrom)
			0: writeBackDataTMP = readData;
			1: writeBackDataTMP = aluResult;
			2: writeBackDataTMP = extended_imm;
		endcase
	 end 
	 assign writeBackData = writeBackDataTMP;

endmodule