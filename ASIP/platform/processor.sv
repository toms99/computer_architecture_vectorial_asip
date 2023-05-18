module processor #(
    parameter registerSize = 8,
    parameter registerQuantity = 4,
    parameter selectionBits = 4,
    parameter vectorSize = 4
) (input clk, rst);

	logic [15:0] instruction_d, ReadData;
	logic [15:0] PC;
	logic [15:0] dataAddress, WriteData;
	logic [1:0] WriteRegFrom;
	logic [3:0] RegToWrite;
	logic [registerSize-1:0] Immediate, newPc;
	logic regWriteEnSc, regWriteEnVec, pcWrEn;
	
	// Variables que entran al Memory Stage
	logic MemoryWrite_Mem, regWriteEnSc_Mem, regWriteEnVec_Mem;
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
	logic [vectorSize-1:0] [registerSize-1:0] matrix_zero, matrix_zero_b;
	
	
    // ####### FETCH STAGE #######
    logic [15:0] instruction_f;
	fetchStage fetch(
        .clk(clk), .reset(rst), .newPc(writeBackData_Mem[0]),
        .pcWrEn(PCWrEn_Mem), .instruction(instruction_f)
    );
	
	pipe #(16) p_fetch_deco(clk, rst, instruction_f, instruction_d);
	
    // ######## DECODE STAGE ########
    logic [2:0] pcWrEn_dec;
    logic OverWriteNz_dec, MemoryWrite_dec, regWriteEnSc_dec,
          regWriteEnVec_dec;
    logic [1:0] writeRegFrom_dec;
    logic [3:0] RegToWrite_dec;
    logic [registerSize-1:0] Immediate_dec;
    logic [2:0] AluOpCode_dec;

	decoderStage decoder_stage(
        .instruction(instruction_d), .MemoryWrite(MemoryWrite_dec),
        .WriteRegFrom(writeRegFrom_dec), .RegToWrite(RegToWrite_dec),
        .Immediate(Immediate_dec), .RegWriteEnSc(regWriteEnSc_dec),
        .RegWriteEnVec(regWriteEnVec_dec), .PcWriteEn(pcWrEn_dec),
        .OverWriteNz(OverWriteNz_dec), .AluOpCode(AluOpCode_dec));

    logic [vectorSize-1:0] [registerSize-1:0] operand1_dec, operand2_dec;
    regFile #(
        .registerSize(registerSize), .registerQuantity(registerQuantity),
        .selectionBits(selectionBits), .vectorSize(vectorSize)
    ) registerFile(
        .clk(clk), .reset(rst), .regWrEnSc(regWriteEnSc_chip),
        .regWrEnVec(regWriteEnVec_chip), .rSel1(instruction_d[11:8]),
        .rSel2(instruction_d[7:4]), .regToWrite(RegToWrite_chip),
        .dataIn(writeBackData_chip), .operand1(operand1_dec), .operand2(operand2_dec)
    );
	 
	// Pipe De-EX
	logic [registerSize-1+16:0] condensed_decode_in, condensed_decode_out;
	assign condensed_decode_in = {MemoryWrite_dec, writeRegFrom_dec,
                                  RegToWrite_dec, Immediate_dec,
                                  regWriteEnSc_dec, regWriteEnVec_dec,
                                  pcWrEn_dec, OverWriteNz_dec,
                                  AluOpCode_dec};
	logic [vectorSize-1:0] [registerSize-1:0] operand1_ex, operand2_ex;

 	pipe_vect #(
        registerSize+16, registerSize, vectorSize
    ) p_decode_ex(
        clk, rst, condensed_decode_in, operand1_dec, operand2_dec,
        condensed_decode_out, operand1_ex, operand2_ex
    );
	
	// Variables que entran al execute
	logic MemoryWrite_ex, regWriteEnSc_ex, regWriteEnVec_ex, OverWriteNz_ex;
    logic [1:0] writeRegFrom_ex;
    logic [2:0] pcWrEn_ex, AluOpCode_ex;
    logic [3:0] RegToWrite_ex;
    logic [registerSize-1:0] Immediate_ex;
	assign {MemoryWrite_ex, writeRegFrom_ex,
            RegToWrite_ex, Immediate_ex,
            regWriteEnSc_ex, regWriteEnVec_ex,
            pcWrEn_ex, OverWriteNz_ex,
            AluOpCode_ex} = condensed_decode_out;
	
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
	 logic [registerSize-1+10:0] condensed_mem_in, condensed_mem_out;
	 assign condensed_mem_in =  {MemoryWrite_ex, Immediate_ex, writeRegFrom_ex,
                                 RegToWrite_ex, pcWrEn_ex_out, regWriteEnSc_ex, 
                                 regWriteEnVec_ex};
	 pipe_vect #(registerSize+10, registerSize, vectorSize) p_ex_mem(clk, rst, condensed_mem_in, result_ex, matrix_zero, condensed_mem_out, alu_result_mem, matrix_zero);
						
	
    // ######## WRITE-BACK STAGE ########
    assign {MemoryWrite_Mem, Immediate_Mem, WriteRegFrom_Mem, RegToWrite_Mem,
				PCWrEn_Mem, regWriteEnSc_Mem, regWriteEnVec_Mem} = condensed_mem_out;
    stage_writeback #(
        .vecSize(vectorSize), .registerSize(registerSize)
    ) writeback_stage (
        .clk(clk), .reset(rst), .writeEnable(MemoryWrite_Mem),
        .writeRegFrom(WriteRegFrom_Mem), .address(Immediate_Mem),
        .imm(Immediate_Mem), .writeData(alu_result_mem),
        .aluResult(alu_result_mem), .writeBackData(writeBackData_Mem)
    );
	 
	 
	 
	 // Pipe Mem-Chip
	 logic [5:0] condensed_chip_in, condensed_chip_out;
	 assign condensed_chip_in = {RegToWrite_Mem, regWriteEnVec_Mem, regWriteEnSc_Mem};
	 pipe_vect #(6, registerSize, vectorSize) p_mem_chip(clk, rst, condensed_chip_in, writeBackData_Mem, matrix_zero_b, condensed_chip_out, writeBackData_chip, matrix_zero_b);

	 assign {RegToWrite_chip, regWriteEnVec_chip, regWriteEnSc_chip} = condensed_chip_out;

	 
	 
endmodule