`timescale 1ps/1ps
module scalarRegFile_test #(
    parameter registerSize = 8,
    parameter registerQuantity = 4,
    parameter selectionBits = 2
)();

    logic clk, reset, regWrEn;
    logic [selectionBits-1:0] rSel1, rSel2, regToWrite;
    logic [registerSize-1:0] dataIn;
    logic [registerSize-1:0] reg1Out, reg2Out;

    scalarRegisterFile #(
        .registerSize(registerSize), .registerQuantity(registerQuantity),
        .selectionBits(selectionBits)
    ) scalarRegs(
        .clk(clk), .reset(reset),
        .regWrEn(regWrEn), .rSel1(rSel1),
        .rSel2(rSel2), .regToWrite(regToWrite),
        .dataIn(dataIn), .reg1Out(reg1Out), .reg2Out(reg2Out)
    );

    always #5 clk = ~clk;
    initial begin
        clk = 0;
        reset = 1;
        regWrEn = 0;
        rSel1 = 0;
        rSel2 = 0;
        regToWrite = 0;
        dataIn = 0;
        
        // Write to register 1
        #10
        reset = 0;
        regWrEn = 1;
        regToWrite = 1;
        dataIn = 8'hFE;
        // Should be able to read what we wrote
        rSel1 = 1;
        #10
        assert (reg1Out == 8'hFE) else $error("Register 1 read incorrect");
        assert (reg2Out == 8'h0) else $error("Register port 2 read incorrect");
        #10 // Write to register 3
        regWrEn = 1;
        regToWrite = 3;
        dataIn = 8'hFA;
        // Should be able to read what we wrote
        rSel1 = 3;
        #10
        assert (reg1Out == 8'hFA) else $error("Register 14 read incorrect");
        assert (reg2Out == 8'h0) else $error("Register port 2 read incorrect");

        #10 // Reading both ports
        rSel1 = 1;
        rSel2 = 3;
        #10
        assert (reg1Out == 8'hFE) else $error("Register port 1 read incorrect");
        assert (reg2Out == 8'hFA) else $error("Register port 2 read incorrect");
        #20;
    end

endmodule