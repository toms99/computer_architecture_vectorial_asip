`timescale 1ps / 1ps
module regFile_test #(
    parameter registerSize = 8,
    parameter registerQuantity = 4,
    parameter selectionBits = 2,
    parameter vectorSize = 4
)();

    logic clk, reset;
    logic regWrEnSc, regWrEnVec;
    // MSB used for selector
    logic [selectionBits:0] rSel1, rSel2;
    logic [selectionBits:0] regToWrite;
    // Outputs
    logic [vectorSize-1:0] [registerSize-1:0] dataIn;
    logic [vectorSize-1:0] [registerSize-1:0] operand1, operand2;

    regFile #(
        registerSize, registerQuantity, selectionBits, vectorSize
    ) regFile(
        .clk(clk),
        .reset(reset),
        .regWrEnSc(regWrEnSc),
        .regWrEnVec(regWrEnVec),
        .rSel1(rSel1),
        .rSel2(rSel2),
        .regToWrite(regToWrite),
        .dataIn(dataIn),
        .operand1(operand1),
        .operand2(operand2)
    );

    always #5 clk = ~clk;

    initial begin
        clk = 0;
        reset = 1;

        // Initial conditions
        regWrEnSc = 0;
        regWrEnVec = 0;
        rSel1 = 0;
        rSel2 = 0;
        regToWrite = 0;
        dataIn = 0;

        // Tests:
        // 1. Write to scalar register 0 (reg 4), then read that register in port 1
        // -> Scalar register 0 should have the information (vectorized)
        // -> Port 2 should output 0
        // -> Vectorial register 0 should not have changed
        #10
        reset = 0;
        regWrEnSc = 1;
        regToWrite = 0;
        dataIn = 4;
        // Preparing to read
        rSel1 = 4;
        rSel2 = 1;
        #10
        assert (operand1 == 32'h04040404) else $error("Test 1 failed: operand1 = %d", operand1);
        assert (operand2 == 0) else $error("Test 1 failed: operand2 = %d", operand2);
        // Now we will read vectorial reg 0 (reg 0)
        rSel1 = 0;
        #10
        assert(operand1 == 0) else $error("Test 1 failed: vectorialRegister 0 = %d", operand1);

        // 2. Write to vectorial register 7, then read that register in port 1
        // -> Vectorial register 7 should have the information
        // -> Port 2 should output 0
        // -> Scalar register 7 should not have changed
        // 3. Read from scalar register 0 (reg 8) on port 1, and from vectorial register 7 on port 2
        // -> Port 1 should output the information from scalar register 0 (vectorized)
        // -> Port 2 should output the information from vectorial register 7
        #20
        $finish;

    end

endmodule