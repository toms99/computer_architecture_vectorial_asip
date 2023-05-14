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
	logic [3:0] RegToWrite;
	logic [registerSize-1:0] Immediate, newPc;
	logic regWriteEnSc, regWriteEnVec, pcWrEn;
	
	fetchStage fetch(clk, rst, pcWrEn, newPc, instruction_f);
	
	pipe #(16) p_fetch_deco(clk, rst, instruction_f, instruction_d);
	
	decoderStage decoder_stage(clk,rst,instruction_d, MemoryWrite, WriteRegFrom, RegToWrite, Immediate, regWriteEnSc, regWriteEnVec);

    regFile #(
        .registerSize(registerSize), .registerQuantity(registerQuantity),
        .selectionBits(selectionBits), .vectorSize(vectorSize)
    ) registerFile(
        .clk(clk), .reset(rst), .regWrEnSc(regWriteEnSc),
        .regWrEnVec(regWriteEnVec), .rSel1(instruction_d[11:8]),
        .rSel2(instruction_d[7:4]), .regToWrite(regToWrite),
        .dataIn(writeBackData), .operand1(operand1), .operand2(operand2)
    );
	 
	
	//Pipe De-EX
	logic [registerSize+9:0] condensed_decode_in = {MemoryWrite, WriteRegFrom, RegToWrite, Immediate, regWriteEnSc, regWriteEnVec};
	logic [vectorSize-1:0] [registerSize-1:0] operand1_ex, operand2_ex;
 	pipe_vect #(registerSize+9:0,registerSize, vectorSize) p_decode_ex(clk, rst, condensed_decode_in, operand1, operand2, condensed_decode_out, operand1_ex, operand2_ex);
	
	// Variables que entran al execute
	logic MemoryWrite_Ex, regWriteEnSc_Ex, regWriteEnVec_Ex;
	logic [1:0] WriteRegFrom_Ex; 
	logic [3:0] RegToWrite_Ex;
	logic [registerSize-1:0] Immediate_Ex;
	
	assign {MemoryWrite_Ex,WriteRegFrom_Ex, RegToWrite_Ex, Immediate_Ex, regWriteEnSc_Ex, regWriteEnVec_Ex} = condensed_decode_out;
	
	
	//Stage Execute
	logic [vectorSize-1:0] [registerSize-1:0] operand_ex;
	stage_execute #(registerSize(registerSize),.vectorSize(vectorSize)) 
		(clk, reset, ExecuteOp, PCWrEn, operand1_ex, operand2_ex, operand_ex);
	
	 //Pipe Ex-Mem
	 
						
					  
endmodule