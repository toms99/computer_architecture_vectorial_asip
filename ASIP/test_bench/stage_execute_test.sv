module stage_execute_test #(
    parameter vectorSize = 4,
    parameter registerSize = 8
)();

	logic clk, reset, overwriteFlags, pcWrEn_out;
    logic [2:0] PCWrEn;
    logic [2:0] ExecuteOp;
	logic [vectorSize-1:0] [registerSize-1:0] vect1, vect2;
	logic [vectorSize-1:0] [registerSize-1:0] vect_out;
    logic [1:0] NZ_flags;

    stage_execute #(
        .vectorSize(vectorSize),
        .registerSize(registerSize)
    ) dut (
        .clk(clk),
        .reset(reset),
        .ExecuteOp(ExecuteOp),
        .pcWrEn(PCWrEn),
        .overwriteFlags(overwriteFlags),
        .vect1(vect1),
        .vect2(vect2),
        .vect_out(vect_out),
        .pcWrEn_out(pcWrEn_out)
    );

    always #5 clk = ~clk;

    initial begin
        clk = 0;
        reset = 0;
        ExecuteOp = 0;
        PCWrEn = 0;
        overwriteFlags = 1;
        vect1 = 0;
        vect2 = 0;

        #10;
        reset = 1;
        #10;
        reset = 0;

         // Execute operations
        
        // Operation 1: XOR
        ExecuteOp = 3'b001;
        
        vect1[0] = 8'b00110011;
        vect1[1] = 8'b11001100;
        vect1[2] = 8'b10101010;
        vect1[3] = 8'b01010101;
        
        vect2[0] = 8'b00001111;
        vect2[1] = 8'b11110000;
        vect2[2] = 8'b01010101;
        vect2[3] = 8'b10101010;
        
        // Wait for execution
        #20;
        
        // Check results
        assert(vect_out[0] == 8'b00111100) else $error("Operation 1: Incorrect result for vect_out[0]");
        assert(vect_out[1] == 8'b00111100) else $error("Operation 1: Incorrect result for vect_out[1]");
        assert(vect_out[2] == 8'b11111111) else $error("Operation 1: Incorrect result for vect_out[2]");
        assert(vect_out[3] == 8'b11111111) else $error("Operation 1: Incorrect result for vect_out[3]");
        
        #10;

        // Operation 2: Addition
        ExecuteOp = 3'b010;
        
        vect1[0] = 8'b00110011;
        vect1[1] = 8'b11001100;
        vect1[2] = 8'b10101010;
        vect1[3] = 8'b01010101;

        vect2[0] = 8'b00001111;
        vect2[1] = 8'b11110000;
        vect2[2] = 8'b01010101;
        vect2[3] = 8'b10101010;
        
        // Wait for execution
        #20;
        
        // Check results
        assert(vect_out[0] == 8'b01000010) else $error("Operation 2: Incorrect result for vect_out[0]");
        assert(vect_out[1] == 8'b10111100) else $error("Operation 2: Incorrect result for vect_out[1]");
        assert(vect_out[2] == 8'b11111111) else $error("Operation 2: Incorrect result for vect_out[2]");
        assert(vect_out[3] == 8'b11111111) else $error("Operation 2: Incorrect result for vect_out[3]");
        
        #10;
        
        // Operation 3: Subtraction
        ExecuteOp = 3'b011;
        
        vect1[0] = 8'b00110011;
        vect1[1] = 8'b11001100;
        vect1[2] = 8'b10101010;
        vect1[3] = 8'b01010101;
        
        vect2[0] = 8'b00001111;
        vect2[1] = 8'b11110000;
        vect2[2] = 8'b01010101;
        vect2[3] = 8'b10101010;
        
        // Wait for execution
        #20;
        
        // Check results
        assert(vect_out[0] == 8'b00100100) else $error("Operation 3: Incorrect result for vect_out[0]");
        assert(vect_out[1] == 8'b11011100) else $error("Operation 3: Incorrect result for vect_out[1]");
        assert(vect_out[2] == 8'b01010101) else $error("Operation 3: Incorrect result for vect_out[2]");
        assert(vect_out[3] == 8'b10101011) else $error("Operation 3: Incorrect result for vect_out[3]");
        
        #10;
        
        // Operation 4: Multiplication
        ExecuteOp = 3'b100;
        
        vect1[0] = 8'b00000011;
        vect1[1] = 8'b00001100;
        vect1[2] = 8'b00001010;
        vect1[3] = 8'b00000101;
        
        vect2[0] = 8'b00001111;
        vect2[1] = 8'b00000000;
        vect2[2] = 8'b00000101;
        vect2[3] = 8'b00001010;
        
        // Wait for execution
        #20;

        // Check results
        assert(vect_out[0] == 8'b00101101) else $error("Operation 4: Incorrect result for vect_out[0]");
        assert(vect_out[1] == 8'b00000000) else $error("Operation 4: Incorrect result for vect_out[1]");
        assert(vect_out[2] == 8'b00110010) else $error("Operation 4: Incorrect result for vect_out[2]");
        assert(vect_out[3] == 8'b00110010) else $error("Operation 4: Incorrect result for vect_out[3]");
        
        #10;
        
        // Operation 5: Right Shift
        ExecuteOp = 3'b101;

        vect1[0] = 8'b10101010;
        vect1[1] = 8'b01010101;
        vect1[2] = 8'b11110000;
        vect1[3] = 8'b00001111;

        vect2[0] = 3'b001;
        vect2[1] = 3'b010;
        vect2[2] = 3'b011;
        vect2[3] = 3'b100;

        // Wait for execution
        #20;

        // Check results
        assert(vect_out[0] == 8'b01010101) else $error("Operation 5: Incorrect result for vect_out[0]");
        assert(vect_out[1] == 8'b00010101) else $error("Operation 5: Incorrect result for vect_out[1]");
        assert(vect_out[2] == 8'b00011110) else $error("Operation 5: Incorrect result for vect_out[2]");
        assert(vect_out[3] == 8'b00000000) else $error("Operation 5: Incorrect result for vect_out[3]");

        #10;

        // Operation 6: Left Shift
        ExecuteOp = 3'b110;

        vect1[0] = 8'b10101010;
        vect1[1] = 8'b01010101;
        vect1[2] = 8'b11110000;
        vect1[3] = 8'b00001111;

        vect2[0] = 3'b001;
        vect2[1] = 3'b010;
        vect2[2] = 3'b011;
        vect2[3] = 3'b100;

        // Wait for execution
        #20;

        // Check results
        assert(vect_out[0] == 8'b01010100) else $error("Operation 6: Incorrect result for vect_out[0]");
        assert(vect_out[1] == 8'b01010100) else $error("Operation 6: Incorrect result for vect_out[1]");
        assert(vect_out[2] == 8'b10000000) else $error("Operation 6: Incorrect result for vect_out[2]");
        assert(vect_out[3] == 8'b11110000) else $error("Operation 6: Incorrect result for vect_out[3]");

        #10;

        // Test 7: Zero flag
        ExecuteOp = 3'b011;
        
        vect1[0] = 8'b00110011;
        vect1[1] = 8'b11001100;
        vect1[2] = 8'b10101010;
        vect1[3] = 8'b01010101;
        
        vect2[0] = 8'b00110011;
        vect2[1] = 8'b11001100;
        vect2[2] = 8'b10101010;
        vect2[3] = 8'b01010101;
        #10;
        // Check results
        assert(vect_out[0] == 0) else $error("Test 7: Incorrect result for vect_out[0]");
        assert(vect_out[1] == 0) else $error("Test 7: Incorrect result for vect_out[1]");
        assert(vect_out[2] == 0) else $error("Test 7: Incorrect result for vect_out[2]");
        assert(vect_out[3] == 0) else $error("Test 7: Incorrect result for vect_out[3]");

        #10;

        // Test 8 : Inconditional jump
        PCWrEn = 3'b100;
        #10;
        assert(pcWrEn_out == 1) else $error("Test 8: Incorrect pcWrEn_out");
        #10;
        
        // Test 9: Jump on Zero
        PCWrEn = 3'b010;
        ExecuteOp = 3'b011;
        
        vect1[0] = 8'b00110011;
        vect1[1] = 8'b11001100;
        vect1[2] = 8'b10101010;
        vect1[3] = 8'b01010101;
        
        vect2[0] = 8'b00110011;
        vect2[1] = 8'b11001100;
        vect2[2] = 8'b10101010;
        vect2[3] = 8'b01010101;
        #10;
        // Check results
        assert(vect_out[0] == 0) else $error("Test 7: Incorrect result for vect_out[0]");
        assert(vect_out[1] == 0) else $error("Test 7: Incorrect result for vect_out[1]");
        assert(vect_out[2] == 0) else $error("Test 7: Incorrect result for vect_out[2]");
        assert(vect_out[3] == 0) else $error("Test 7: Incorrect result for vect_out[3]");

        assert(pcWrEn_out == 1) else $error("Test 9: Incorrect pcWrEn_out");

        // Test 10: Jump on negative
        PCWrEn = 3'b001;
        ExecuteOp = 3'b011;
        
        vect1[0] = 8'b00110011;
        vect1[1] = 8'b11001100;
        vect1[2] = 8'b10101010;
        vect1[3] = 8'b01010101;
        
        vect2[0] = 8'b00001111;
        vect2[1] = 8'b11110000;
        vect2[2] = 8'b01010101;
        vect2[3] = 8'b10101010;
        
        // Wait for execution
        #10;
        
        // Check results
        assert(vect_out[0] == 8'b00100100) else $error("Operation 3: Incorrect result for vect_out[0]");
        assert(vect_out[1] == 8'b11011100) else $error("Operation 3: Incorrect result for vect_out[1]");
        assert(vect_out[2] == 8'b01010101) else $error("Operation 3: Incorrect result for vect_out[2]");
        assert(vect_out[3] == 8'b10101011) else $error("Operation 3: Incorrect result for vect_out[3]");

        assert(pcWrEn_out == 1) else $error("Test 10: Incorrect pcWrEn_out");

        #20;

        // Finish simulation
        $display("All test cases finished");
        $finish;
    end


endmodule