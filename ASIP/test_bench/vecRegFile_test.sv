`timescale 1ps/1ps
module vecRegFile_test#(
    parameter registerSize = 8,
    parameter registerQuantity = 4,
    parameter selectionBits = 2,
    parameter vectorSize = 4
)();
    logic clk, reset, regWrEn;
    logic [selectionBits-1:0] rSel1, rSel2, regToWrite;

    logic [vectorSize-1:0] [registerSize-1:0] dataIn, reg1Out, reg2Out;

    vecRegisterFile #(
        .registerSize(registerSize),
        .registerQuantity(registerQuantity),
        .selectionBits(selectionBits),
        .vectorSize(vectorSize)
    ) vecRegs(
        .clk(clk), .reset(reset), .regWrEn(regWrEn),
        .rSel1(rSel1), .rSel2(rSel2), .regToWrite(regToWrite),
        .regWriteData(dataIn), .reg1Out(reg1Out), .reg2Out(reg2Out)
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
        dataIn = 32'hDEADBEEF;
        // Should be able to read what we wrote
        rSel1 = 1;
        #10
        assert (reg1Out[3] == 8'hDE) else $error("Register 1, element 0 read incorrect");
        assert (reg1Out[2] == 8'hAD) else $error("Register 1, element 1 read incorrect");
        assert (reg1Out[1] == 8'hBE) else $error("Register 1, element 2 read incorrect");
        assert (reg1Out[0] == 8'hEF) else $error("Register 1, element 3 read incorrect");

        assert (reg2Out[3] == 8'h0) else $error("Register port 2, element 0 read incorrect");
        assert (reg2Out[2] == 8'h0) else $error("Register port 2, element 1 read incorrect");
        assert (reg2Out[1] == 8'h0) else $error("Register port 2, element 2 read incorrect");
        assert (reg2Out[0] == 8'h0) else $error("Register port 2, element 3 read incorrect");
        #10 // Write to register 3
        regWrEn = 1;
        regToWrite = 3;
        dataIn = 32'h1A2B3C4D;
        // Should be able to read what we wrote
        rSel1 = 3;
        #10
        assert (reg1Out[3] == 8'h1A) else $error("Register 7, element 0 read incorrect");
        assert (reg1Out[2] == 8'h2B) else $error("Register 7, element 1 read incorrect");
        assert (reg1Out[1] == 8'h3C) else $error("Register 7, element 2 read incorrect");
        assert (reg1Out[0] == 8'h4D) else $error("Register 7, element 3 read incorrect");

        assert (reg2Out[3] == 8'h0) else $error("Register port 2, element 0 read incorrect");
        assert (reg2Out[2] == 8'h0) else $error("Register port 2, element 1 read incorrect");
        assert (reg2Out[1] == 8'h0) else $error("Register port 2, element 2 read incorrect");
        assert (reg2Out[0] == 8'h0) else $error("Register port 2, element 3 read incorrect");

        #10 // Reading both ports
        rSel1 = 1;
        rSel2 = 3;
        #10

        assert (reg1Out[3] == 8'hDE) else $error("Register 1, element 0 read incorrect");
        assert (reg1Out[2] == 8'hAD) else $error("Register 1, element 1 read incorrect");
        assert (reg1Out[1] == 8'hBE) else $error("Register 1, element 2 read incorrect");
        assert (reg1Out[0] == 8'hEF) else $error("Register 1, element 3 read incorrect");

        assert (reg2Out[3] == 8'h1A) else $error("Register 7, element 0 read incorrect");
        assert (reg2Out[2] == 8'h2B) else $error("Register 7, element 1 read incorrect");
        assert (reg2Out[1] == 8'h3C) else $error("Register 7, element 2 read incorrect");
        assert (reg2Out[0] == 8'h4D) else $error("Register 7, element 3 read incorrect");
        #20
        $finish;
    end
endmodule