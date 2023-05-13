`timescale 1ps/1ps
module vecRegFile_test();
    logic clk, reset, regWrEn;
    logic [2:0] rSel1, rSel2, regToWrite;

    logic [7:0] dataIn_0;
    logic [7:0] dataIn_1;
    logic [7:0] dataIn_2;
    logic [7:0] dataIn_3;

    logic [7:0] reg1Out_0;
    logic [7:0] reg1Out_1;
    logic [7:0] reg1Out_2;
    logic [7:0] reg1Out_3;

    logic [7:0] reg2Out_0;
    logic [7:0] reg2Out_1;
    logic [7:0] reg2Out_2;
    logic [7:0] reg2Out_3;

    vecRegisterFile #(8, 8) vecRegs(
        .clk(clk), .reset(reset), .regWrEn(regWrEn),
        .rSel1(rSel1), .rSel2(rSel2), .regToWrite(regToWrite),

        .regWriteData_0(dataIn_0), .regWriteData_1(dataIn_1),
        .regWriteData_2(dataIn_2), .regWriteData_3(dataIn_3),
        
        .reg1Out_0(reg1Out_0), .reg1Out_1(reg1Out_1),
        .reg1Out_2(reg1Out_2), .reg1Out_3(reg1Out_3),
        
        .reg2Out_0(reg2Out_0), .reg2Out_1(reg2Out_1),
        .reg2Out_2(reg2Out_2), .reg2Out_3(reg2Out_3)
    );

    always #5 clk = ~clk;
    initial begin
        clk = 0;
        reset = 1;
        regWrEn = 0;
        rSel1 = 0;
        rSel2 = 0;
        regToWrite = 0;
        dataIn_0 = 0;
        dataIn_2 = 0;
        dataIn_3 = 0;
        
        // Write to register 1
        #10
        reset = 0;
        regWrEn = 1;
        regToWrite = 1;
        dataIn_0 = 8'hDE;
        dataIn_1 = 8'hAD;
        dataIn_2 = 8'hBE;
        dataIn_3 = 8'hEF;
        // Should be able to read what we wrote
        rSel1 = 1;
        #10
        assert (reg1Out_0 == 8'hDE) else $error("Register 1, element 0 read incorrect");
        assert (reg1Out_1 == 8'hAD) else $error("Register 1, element 1 read incorrect");
        assert (reg1Out_2 == 8'hBE) else $error("Register 1, element 2 read incorrect");
        assert (reg1Out_3 == 8'hEF) else $error("Register 1, element 3 read incorrect");

        assert (reg2Out_0 == 8'h0) else $error("Register port 2, element 0 read incorrect");
        assert (reg2Out_1 == 8'h0) else $error("Register port 2, element 1 read incorrect");
        assert (reg2Out_2 == 8'h0) else $error("Register port 2, element 2 read incorrect");
        assert (reg2Out_3 == 8'h0) else $error("Register port 2, element 3 read incorrect");
        #10 // Write to register 7
        regWrEn = 1;
        regToWrite = 7;
        dataIn_0 = 8'h1A;
        dataIn_1 = 8'h2B;
        dataIn_2 = 8'h3C;
        dataIn_3 = 8'h4D;
        // Should be able to read what we wrote
        rSel1 = 7;
        #10
        assert (reg1Out_0 == 8'h1A) else $error("Register 7, element 0 read incorrect");
        assert (reg1Out_1 == 8'h2B) else $error("Register 7, element 1 read incorrect");
        assert (reg1Out_2 == 8'h3C) else $error("Register 7, element 2 read incorrect");
        assert (reg1Out_3 == 8'h4D) else $error("Register 7, element 3 read incorrect");

        assert (reg2Out_0 == 8'h0) else $error("Register port 2, element 0 read incorrect");
        assert (reg2Out_1 == 8'h0) else $error("Register port 2, element 1 read incorrect");
        assert (reg2Out_2 == 8'h0) else $error("Register port 2, element 2 read incorrect");
        assert (reg2Out_3 == 8'h0) else $error("Register port 2, element 3 read incorrect");

        #10 // Reading both ports
        rSel1 = 1;
        rSel2 = 7;
        #10

        assert (reg1Out_0 == 8'hDE) else $error("Register 1, element 0 read incorrect");
        assert (reg1Out_1 == 8'hAD) else $error("Register 1, element 1 read incorrect");
        assert (reg1Out_2 == 8'hBE) else $error("Register 1, element 2 read incorrect");
        assert (reg1Out_3 == 8'hEF) else $error("Register 1, element 3 read incorrect");

        assert (reg2Out_0 == 8'h1A) else $error("Register 7, element 0 read incorrect");
        assert (reg2Out_1 == 8'h2B) else $error("Register 7, element 1 read incorrect");
        assert (reg2Out_2 == 8'h3C) else $error("Register 7, element 2 read incorrect");
        assert (reg2Out_3 == 8'h4D) else $error("Register 7, element 3 read incorrect");
        #20
        $finish;
    end
endmodule