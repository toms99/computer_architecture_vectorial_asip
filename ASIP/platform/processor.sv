module processor #(
	 parameter instructionSize = 24,
    parameter registerSize = 16,
    parameter registerQuantity = 4,
    parameter selectionBits = 4,
    parameter vectorSize = 4
) (
    input clk, rst,
    input logic [9:0] vga_adr,
    output [7:0] vga_pixel
);

	logic [instructionSize -1:0] instruction_d, ReadData;
	logic [15:0] PC;
	logic [15:0] dataAddress, WriteData;
	logic [1:0] WriteRegFrom;
	logic [3:0] RegToWrite;
	logic [registerSize-1:0] Immediate, newPc;
	logic regWriteEnSc, regWriteEnVec, pcWrEn;
	
	// Variables que entran al Memory Stage
	logic MemoryWrite_Mem, regWriteEnSc_Mem, regWriteEnVec_Mem, writeMemFrom_Mem;
	logic [1:0] WriteRegFrom_Mem; 
	logic [3:0] RegToWrite_Mem;
	logic [registerSize-1:0] Immediate_Mem;
	logic PCWrEn_Mem;
   logic [vectorSize-1:0] [registerSize-1:0] writeBackData_Mem, writeBackData_chip;
	
	
	// Variables que salen de Memory stage y entran de vuelta al chip
	logic regWriteEnSc_chip, regWriteEnVec_chip;	
	logic [3:0] RegToWrite_chip;

	//Matriz de ceros
	// Inicializar la matriz a cero
	logic [vectorSize-1:0] [registerSize-1:0] matrix_zero, matrix_zero_b, matrix_zero_c, matrix_zero_d, matrix_zero_e, matrix_zero_f;
	
	
    // ####### FETCH STAGE #######
    logic [instructionSize -1:0] instruction_f;
	fetchStage fetch(
        .clk(clk), .reset(rst), .newPc(writeBackData_Mem[0]),
        .pcWrEn(PCWrEn_Mem), .instruction(instruction_f)
    );
	
	pipe #(instructionSize) p_fetch_deco(clk, rst, instruction_f, instruction_d);
	
    // ######## DECODE STAGE ########
    logic [2:0] pcWrEn_dec;
    logic OverWriteNz_dec, MemoryWrite_dec, regWriteEnSc_dec,
          regWriteEnVec_dec, writeMemFrom_Dec;
    logic [1:0] writeRegFrom_dec;
    logic [3:0] RegToWrite_dec;
    logic [registerSize-1:0] Immediate_dec;
    logic [2:0] AluOpCode_dec;

	decoderStage #(instructionSize, registerSize) decoder_stage
			(
        .instruction(instruction_d), .MemoryWrite(MemoryWrite_dec),
        .WriteRegFrom(writeRegFrom_dec), .RegToWrite(RegToWrite_dec),
        .Immediate(Immediate_dec), .RegWriteEnSc(regWriteEnSc_dec),
        .RegWriteEnVec(regWriteEnVec_dec), .PcWriteEn(pcWrEn_dec),
        .OverWriteNz(OverWriteNz_dec), .AluOpCode(AluOpCode_dec),
        .writeMemFrom(writeMemFrom_Dec));

    logic [vectorSize-1:0] [registerSize-1:0] operand1_dec, operand2_dec;
    regFile #(
        .registerSize(registerSize), .registerQuantity(registerQuantity),
        .selectionBits(selectionBits), .vectorSize(vectorSize)
    ) registerFile(
        .clk(clk), .reset(rst), .regWrEnSc(regWriteEnSc_chip),
        .regWrEnVec(regWriteEnVec_chip), .rSel1(instruction_d[instructionSize - 5: instructionSize - 8]),
        .rSel2(instruction_d[instructionSize - 9: instructionSize - 12]), .regToWrite(RegToWrite_chip),
        .dataIn(writeBackData_Mem), .operand1(operand1_dec), .operand2(operand2_dec)
    );
	 
	// Pipe De-EX
	logic [registerSize-1+17:0] condensed_decode_in, condensed_decode_out;
	assign condensed_decode_in = {MemoryWrite_dec, writeRegFrom_dec,
                                  RegToWrite_dec, Immediate_dec,
                                  regWriteEnSc_dec, regWriteEnVec_dec,
                                  pcWrEn_dec, OverWriteNz_dec,
                                  AluOpCode_dec, writeMemFrom_Dec};
	logic [vectorSize-1:0] [registerSize-1:0] operand1_ex, operand2_ex,operand1_mem, operand2_mem;

 	pipe_vect #(
        registerSize+17, registerSize, vectorSize
    ) p_decode_ex(
        clk, rst, condensed_decode_in, operand1_dec, operand2_dec, matrix_zero,
        condensed_decode_out, operand1_ex, operand2_ex, matrix_zero
    );
	
	// Variables que entran al execute
	logic MemoryWrite_ex, regWriteEnSc_ex, regWriteEnVec_ex, OverWriteNz_ex,
          writeMemFrom_Ex;
    logic [1:0] writeRegFrom_ex;
    logic [2:0] pcWrEn_ex, AluOpCode_ex;
    logic [3:0] RegToWrite_ex;
    logic [registerSize-1:0] Immediate_ex;
	assign {MemoryWrite_ex, writeRegFrom_ex,
            RegToWrite_ex, Immediate_ex,
            regWriteEnSc_ex, regWriteEnVec_ex,
            pcWrEn_ex, OverWriteNz_ex,
            AluOpCode_ex, writeMemFrom_Ex} = condensed_decode_out;
	
    // ######## EXECUTE STAGE ########
	logic [vectorSize-1:0] [registerSize-1:0] result_ex, alu_result_mem;
   logic pcWrEn_ex_out;
	stage_execute #(.registerSize(registerSize),.vectorSize(vectorSize)) execute_stage
	(   
        .clk(clk), .reset(rst), .overwriteFlags(OverWriteNz_ex),
        .ExecuteOp(AluOpCode_ex), .pcWrEn(pcWrEn_ex), .vect1(operand1_ex), 
        .vect2(operand2_ex), .vect_out(result_ex), .pcWrEn_out(pcWrEn_ex_out)
    );
	
	 //Pipe Ex-Mem
	 logic [registerSize-1+11:0] condensed_mem_in, condensed_mem_out;
	 assign condensed_mem_in =  {MemoryWrite_ex, Immediate_ex, writeRegFrom_ex,
                                 RegToWrite_ex, pcWrEn_ex_out, regWriteEnSc_ex, 
                                 regWriteEnVec_ex, writeMemFrom_Ex};
	 pipe_vect #(registerSize+11, registerSize, vectorSize) p_ex_mem(clk, rst, condensed_mem_in, result_ex, operand2_ex, operand1_ex, 
																						condensed_mem_out, alu_result_mem, operand2_mem, operand1_mem);
						
	
    // ######## WRITE-BACK STAGE ########
    assign {MemoryWrite_Mem, Immediate_Mem, WriteRegFrom_Mem, RegToWrite_Mem,
			PCWrEn_Mem, regWriteEnSc_Mem, regWriteEnVec_Mem,
            writeMemFrom_Mem} = condensed_mem_out;
    stage_writeback #(
        .vecSize(vectorSize), .registerSize(registerSize)
    ) writeback_stage (
        .clk(clk), .reset(rst), .writeEnable(MemoryWrite_Mem), .alu_operand2(operand2_mem),
        .writeRegFrom(WriteRegFrom_Mem), .vga_adr(vga_adr), .vga_pixel(vga_pixel),
        .imm(Immediate_Mem), .alu_operand1(operand1_mem), .writeMemFrom(writeMemFrom_Mem),
        .aluResult(alu_result_mem), .writeBackData(writeBackData_Mem)
    );
	 
	 
	 
	 // Pipe Mem-Chip
	 logic [5:0] condensed_chip_in, condensed_chip_out;
	 assign condensed_chip_in = {RegToWrite_Mem, regWriteEnVec_Mem, regWriteEnSc_Mem};
	 pipe_vect #(6, registerSize, vectorSize) p_mem_chip(clk, rst, condensed_chip_in, writeBackData_Mem, matrix_zero_b, matrix_zero_c,
																			condensed_chip_out, writeBackData_chip, matrix_zero_b, matrix_zero_c);

	 assign {RegToWrite_chip, regWriteEnVec_chip, regWriteEnSc_chip} = condensed_chip_out;

	 
endmodule