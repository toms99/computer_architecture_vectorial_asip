module fetchStage(
    input clk, input reset, input pcWrEn,
    input [7:0] newPc,
    output [15:0] instruction
);

    logic [7:0] pcM4, choosedPc, pc;

    register pcReg(
        .clk(clk),
        .reset(reset),
        .dataIn(choosedPc),
        .dataOut(pc) );
    pcM4 = pc + 4;
    choosedPc = pcWrEn ? newPc : pcM4;

    instruction_memory rom(
        .address(choosedPc),
        .rdata(instruction) );

endmodule