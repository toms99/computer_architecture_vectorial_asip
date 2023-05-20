module stage_writeback_test #(
    parameter vecSize = 4,
    parameter registerSize = 8
) ();

    logic clk, reset, writeEnable, writeMemFrom;
    logic [1:0] writeRegFrom;
    logic [registerSize-1:0] address, imm, alu_operand2;
    logic [vecSize-1:0] [registerSize-1:0] writeData, aluResult, writeBackData;

    stage_writeback #(vecSize, registerSize) writeback (
        .clk(clk), .reset(reset), .writeEnable(writeEnable), .alu_operand2(alu_operand2),
        .writeRegFrom(writeRegFrom), .imm(imm), .writeMemFrom(writeMemFrom),
        .writeData(writeData), .aluResult(aluResult), .writeBackData(writeBackData)
    );

    always #5 clk = ~clk;

    initial begin
        clk = 0;
        reset = 1;
        writeEnable = 0;
        writeRegFrom = 0;
        address = 0;
        imm = 0;
        writeData = 0;
        aluResult = 0;
        writeMemFrom = 0;
        // Tests:
        // 1. Read Address 0
        // -> Should be 0
        #10
        reset = 0;
        #10
        assert(writeBackData == 0) else $error("Test 1 failed: Reading an empty address");
        // 2. Write Address 4, then read address 4
        // -> Should be what we wrote
        #10
        writeEnable = 1;
        address = 4;
        writeData = 32'hDEADBEEF;
        #10
        writeEnable = 0;
        #10 // DOWN
        assert(writeBackData == 32'hDEADBEEF) else $error("Test 2 failed: Reading an address we just wrote");
        // 2. Pass an immediate, read address 4, select immediate
        // -> Should be the immediate
        #10
        imm = 8'hFE;
        writeRegFrom = 2;
        address = 4;
        #10
        assert(writeBackData == 32'hFEFEFEFE) else $error("Test 3 failed: Reading an immediate");
        // 3. Pass an aluResult, read address 4, select aluResult
        // -> Should be the aluResult
        #10 
        address = 4;
        aluResult = 32'hCAFEBABE;
        writeRegFrom = 1;
        #10
        assert (writeBackData == 32'hCAFEBABE) else $error("Test 4 failed: Reading an aluResult");
        #10;
        // 4. Write to address on reg, read address on reg
        // -> Should be the same
        writeMemFrom = 1;
        writeRegFrom = 0;
        alu_operand2 = 8;
        writeEnable = 1;
        writeData = 32'hBEEFBEEF;
        #10;
        writeEnable = 0;
        #10;
        assert(writeBackData == 32'hBEEFBEEF) else $error("Test 5 failed: Writing and reading on register address");
        #20;
        $finish;
    end

endmodule