module processor #(
    parameter registerSize = 8,
    parameter registerQuantity = 4,
    parameter selectionBits = 2,
    parameter vectorSize = 4
) (input clk, rst);

	logic [15:0] instruction_f, instruction_d, ReadData;
	logic [15:0] PC;
	logic MemoryWrite;
	logic [15:0] dataAddress, WriteData;
    logic [vectorSize-1:0] [registerSize-1:0] writeBackData;
    logic [vectorSize-1:0] [registerSize-1:0] operand1, operand2;
	logic [1:0] WriteRegFrom;
	logic [3:0] regToWrite;
	logic [registerSize-1:0] Immediate, newPc;
	logic regWriteEnSc, regWriteEnVec, pcWrEn;
	
	fetchStage fetch(clk, rst, pcWrEn, newPc, instruction_f);
	
	pipe #(16) p_fetch_deco(clk, rst, instruction_f, instruction_d);
	
	decoderStage decoder(clk,rst,instruction_d, MemoryWrite, WriteRegFrom, RegToWrite, Immediate, RegWriteEn);

    regFile #(
        .registerSize(registerSize), .registerQuantity(registerQuantity),
        .selectionBits(selectionBits), .vectorSize(vectorSize)
    ) registerFile(
        .clk(clk), .reset(rst), .regWrEnSc(regWriteEnSc),
        .regWrEnVec(regWriteEnVec), .rSel1(instruction_d[11:8]),
        .rSel2(instruction_d[7:4]), .regToWrite(regToWrite),
        .dataIn(writeBackData), .operand1(operand1), .operand2(operand2)
    );
						
					  
endmodule