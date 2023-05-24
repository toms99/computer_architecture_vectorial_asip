module decoderStage #(parameter N=24, parameter registerSize = 16)
					 (input logic [N-1:0] instruction,
						output logic MemoryWrite,
						output logic [1:0] WriteRegFrom, //Bandera que indica de donde viene lo que vamos a escribir en el registro (memoria, imm, ALU)
						output logic [3:0] RegToWrite,
						output logic [registerSize - 1:0] Immediate,
                  output logic writeMemFrom,
						output logic RegWriteEnSc,
						output logic RegWriteEnVec,
						output logic [2:0] PcWriteEn,
						output logic OverWriteNz,
						output logic [2:0] AluOpCode
);
    logic memoryInstruction, regWriteEn, preliminar_write_reg_from_1;
    logic jump_instruction, inc_instruction;
		
    assign jump_instruction = instruction[N - 1] && ~instruction[N - 2];
    assign memoryInstruction = instruction[N - 1] && instruction[N -2];

    // Outputs

    assign PcWriteEn = {
        instruction[N - 1] && ~instruction[N - 2] && ~instruction[N - 3] && instruction[N - 4],
        instruction[N - 1] && ~instruction[N - 2] && ~instruction[N - 3] && ~instruction[N - 4],
        instruction[N - 1] && instruction[N - 2] && instruction[N - 3] && instruction[N - 4]
    };
	 


    assign MemoryWrite = memoryInstruction && ~instruction[N - 3] && ~instruction[N - 4];

    assign AluOpCode = instruction[N - 2:N - 4];

    assign preliminar_write_reg_from_1 = ~instruction[N - 1] & ~instruction[N - 2] & ~instruction[N - 3] & ~instruction[N - 4];
    assign WriteRegFrom[0] = preliminar_write_reg_from_1 ? 1'b0 : ~instruction[N - 1];
    assign WriteRegFrom[1] = (jump_instruction) ? jump_instruction : preliminar_write_reg_from_1;

    assign OverWriteNz = ~instruction[N - 1] & (|instruction[N - 2:N - 4]);

    assign RegToWrite = instruction[N - 5:N - 8];

	assign Immediate = instruction[N - 9:0];
    assign writeMemFrom = memoryInstruction && ~instruction[N - 3];

    assign regWriteEn = (memoryInstruction && instruction[N - 4]) | ~instruction[N -1];
    assign RegWriteEnSc = regWriteEn & (instruction[N - 6] || instruction[N - 5]);
    assign RegWriteEnVec = regWriteEn & ~instruction[N - 6] & ~instruction[N - 5];
	
endmodule
