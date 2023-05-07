module top #(parameter N=8)(input clk, rst,
									 output logic [31:0] WriteData, DataAdr, 
									 output logic MemWrite);
									 
	logic [31:0] PC, instruction, ReadData;	
	logic [31:0] text[703:0];
	
	assign PC = 0;
	instruction_memory rom (PC,instruction);
	
	//processor proc(clk, rst, instruction, ReadData, PC,MemWrite, DataAdr, WriteData);
						
	
	data_memory ram(clk, MemWrite,	DataAdr, WriteData, ReadData, text);
	
	
endmodule