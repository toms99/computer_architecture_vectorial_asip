module fetchStage(
    input clk, input reset, input pcWrEn,
    input [7:0] newPc,
    output [15:0] instruction
);

    logic [7:0] pcM4, chosePc, pc;

    register pcReg(		//PC register
        .clk(clk),
        .reset(reset),
        .data_in(chosePc),
        .data_out(pc) );
		  

    assign chosePc = pcWrEn ? newPc : pcM4; //Mux
	 instruction_memory rom(.address(chosePc),.rdata(instruction)); //ROM
	 assign pcM4 = pc + 4;						  //PC + 4	

endmodule