module processor();

	logic clk, rst, 
	logic [15:0] instruction_f, instruction_d, ReadData,
	logic [15:0] PC,
	logic MemoryWrite,
	logic [15:0] dataAddress, WriteData
	logic [1:0] WriteRegFrom;
	logic [3:0] RegToWrite;
	logic [7:0] Immediate, [7:0] newPc;
	logic RegWriteEn, pcWrEn;
	
	fetchStage fetch(clk, rst, pcWrEn, newPc, instruction_f);
	
	pipe #(16) p_fetch_deco(clk, rst, instruction_f, instruction_d);
	
	decoderStage decoder(clk,rst,instruction_d, MemoryWrite, WriteRegFrom, RegToWrite, Immediate, RegWriteEn);
						
					  
endmodule