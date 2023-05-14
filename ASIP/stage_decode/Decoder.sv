module Decoder #(parameter N=16)
					 (input logic [N-1:0] instruction,
						output logic MemoryWrite,
						output logic [1:0] WriteRegFrom, //Bandera que indica de donde viene lo que vamos a escribir en el registro (memoria, imm, ALU)
						output logic [3:0] RegToWrite,
						output logic [7:0] Immediate,
						output logic RegWriteEnSc,
						output logic RegWriteEnVec);
						
	logic [3:0] opcode;
	logic [3:0] register_1;
	logic [7:0] imm;
	logic RegWriteEn;
	
	
	// Decodificacion por condiciones
	always_comb begin
		opcode = instruction[15:12];
		register_1 = instruction[11:8];
		imm = instruction[7:0];
		
		if (opcode[0] || opcode[1] || opcode[2] || opcode[3]) begin //Cualquier instruccion excepto LOSC
			WriteRegFrom = {1'b0, ~opcode[3]}; // 0 -> Escribir desde memoria y 1 -> Desde ALU
		end else begin
			WriteRegFrom = 2'b10; // LOSC - Load scalar - Escribir a registro desde inmediato
		end	
	end
	
	
	//Decodificacion directa
	assign MemoryWrite = opcode == 4'b1100; // Escribir a memoria si opcode = SUPIX
	assign RegWriteEn = ~opcode[0] || opcode[1] & opcode[2];
	assign RegToWrite = register_1;
	assign Immediate = imm;
	assign RegWriteEnSc = RegWriteEn & register_1[2];
	assign RegWriteEnVec = RegWriteEn & ~register_1[2];
	
endmodule
