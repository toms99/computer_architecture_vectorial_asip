module decoder_test();
	
	logic [15:0] instruction;
	logic MemoryWrite, RegWriteEnSc, OverwriteNZ;
	logic [1:0] WriteRegFrom;
	logic [3:0] RegToWrite;
	logic [7:0] Immediate;
	logic [2:0] ExecuteOp;

	
	Decoder decoder
					 (.instruction(instruction),
						.MemoryWrite(MemoryWrite),
						.ExecuteOp(ExecuteOp),
						.WriteRegFrom(WriteRegFrom),
						.OverwriteNZ(OverwriteNZ),
						.RegToWrite(RegToWrite),
						.Immediate(Immediate),
						.RegWriteEnSc(RegWriteEnSc),
						.RegWriteEnVec(RegWriteEnVec));

	
	initial begin
       instruction = 16'hF39D; //1111 0011 1001 1101 
		 #10
		 instruction = 16'h5678; //0101 0110 0111 1000
		 #10;
				
    end

endmodule
						