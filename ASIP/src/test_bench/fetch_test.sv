module fetch_test();

    logic clk, reset, pcWrEn;
    logic [7:0] newPc;
    logic [15:0] instruction;

    fetchStage fetch(
        .clk(clk), .reset(reset),
        .pcWrEn(pcWrEn), .newPc(newPc),
        .instruction(instruction)
    );

    always #5 clk = ~clk;

    initial begin
        clk = 0;
        reset = 1;
        pcWrEn = 0;
        #10 
            reset = 0;
            assert (instruction == 16'h0004) else $error("Instruction is not 16'h0004");
        #10
            assert (instruction == 16'h1008) else $error("Instruction is not 16'h0004");
        #5
            pcWrEn = 1;
            newPc = 8'h04;
        #5
            assert (instruction == 16'h1008) else $error("Instruction override wrong");
        #50
        $finish;
    end

endmodule;