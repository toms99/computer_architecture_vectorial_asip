module decoderStage #(parameter N=16)
					 (input logic [N-1:0] instruction,
						output logic MemoryWrite,
						output logic [1:0] WriteRegFrom, //Bandera que indica de donde viene lo que vamos a escribir en el registro (memoria, imm, ALU)
						output logic [3:0] RegToWrite,
						output logic [7:0] Immediate,
						output logic RegWriteEnSc,
						output logic RegWriteEnVec,
                        output logic [2:0] PcWriteEn,
                        output logic OverWriteNz,
                        output logic [2:0] AluOpCode
);
    logic memoryInstruction, regWriteEn, preliminar_write_reg_from_1;
    logic jump_instruction, inc_instruction;
		
    assign jump_instruction = instruction[15] && ~instruction[14];
    assign memoryInstruction = instruction[15] && instruction[14];

    // Outputs

    assign PcWriteEn = {
        instruction[15] && ~instruction[14] && instruction[13] && ~instruction[12],
        instruction[15] && ~instruction[14] && ~instruction[13] && ~instruction[12],
        instruction[15] && ~instruction[14] && ~instruction[13] && instruction[12]
    };

    assign MemoryWrite = memoryInstruction && ~instruction[13] && ~instruction[12];

    assign AluOpCode = instruction[14:12];

    assign preliminar_write_reg_from_1 = ~instruction[15] & ~instruction[14] & ~instruction[13] & ~instruction[12];
    assign WriteRegFrom[0] = preliminar_write_reg_from_1 ? 0 : ~instruction[15];
    assign WriteRegFrom[1] = (jump_instruction) ? jump_instruction : preliminar_write_reg_from_1;

    assign OverWriteNz = ~instruction[15] & (|instruction[14:12]);

    assign RegToWrite = instruction[11:8];

	assign Immediate = instruction[7:0];

    assign regWriteEn = (memoryInstruction && instruction[12]) | ~instruction[15];
    assign RegWriteEnSc = regWriteEn & instruction[10];
    assign RegWriteEnVec = regWriteEn & ~instruction[10];
	
endmodule
