module processor(input clk, rst, 
					  input logic [31:0] instruction, ReadData,
					  output logic [31:0] PC,
					  output logic MemoryWrite,
					  output logic [31:0] dataAddress, WriteData);
					  
	logic [1:0] WriteRegFrom;
	logic [3:0] RegToWrite;
	logic [7:0] Immediate;
	logic RegWriteEn;
	
	Decoder decoder(instruction, MemoryWrite, WriteRegFrom, RegToWrite, Immediate, RegWriteEn);
	
	assign PC = 0;	
						
					  
endmodule