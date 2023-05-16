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

    assign writeBackData = writeRegFrom == 0 ? readData :
                    writeRegFrom == 1 ? aluResult:
                    extended_imm;

endmodule