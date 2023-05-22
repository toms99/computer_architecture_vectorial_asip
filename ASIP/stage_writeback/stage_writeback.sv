module stage_writeback #(
    parameter vecSize = 4,
    parameter registerSize = 16
) (
   input clk, reset, writeEnable, writeMemFrom,
   input [1:0] writeRegFrom,
   input [registerSize-1:0] imm,
   input [vecSize-1:0] [registerSize-1:0] aluResult, alu_operand2, alu_operand1,
   output [vecSize-1:0] [registerSize-1:0] writeBackData
);
    
    logic [vecSize-1:0] [registerSize-1:0] readData, extended_imm, imm_delayed,
        writeData_delayed, writeData, matrix_zero;
    logic [registerSize-1:0] address;
	logic [1:0] writeRegFrom_delayed;

	  // TODO: Does this alu_operand2 has to be delayed as well?
    assign address = writeMemFrom ? alu_operand2[0] : imm;
	 assign writeData = writeMemFrom ? alu_operand1 : aluResult;
	 
	 
	pipe_vect #(2, registerSize, vecSize) p_mem_chip(clk, rst, writeRegFrom, writeData, extended_imm, matrix_zero,
													 writeRegFrom_delayed, writeData_delayed, imm_delayed, matrix_zero);
     

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
		case (writeRegFrom_delayed)
			0: writeBackDataTMP = readData;
			1: writeBackDataTMP = writeData_delayed;
			2: writeBackDataTMP = imm_delayed;
		endcase
	 end 
	 assign writeBackData = writeBackDataTMP;

endmodule