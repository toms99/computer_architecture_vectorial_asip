module alu_test #(
    parameter dataSize = 8
) ();

    logic [2:0] operation_select;
    logic [dataSize-1:0] operand1, operand2;
    logic [dataSize-1:0] result;
    logic neg_flag, zero_flag;

    alu #(.dataSize(dataSize)) alu(
        .operation_select(operation_select),
        .operand1(operand1), .operand2(operand2),
        .result(result), .neg_flag(neg_flag), .zero_flag(zero_flag)
    );

    initial begin
        // Tests:
        // 1: 1 + 3 = 4
        operation_select = 3'b010;
        operand1 = 1;
        operand2 = 3;
        #10
        assert (result == 4) else $error("Test 1, sum failed");
        #10
        // 2: 3 - 2 = 1
        operation_select = 3'b011;
        operand1 = 3;
        operand2 = 2;
        #10
        assert (result == 1) else $error("Test 2, sub failed");
        #10
        // 3: 3 * 2 = 6
        operation_select = 3'b100;
        operand1 = 3;
        operand2 = 2;
        #10
        assert (result == 6) else $error("Test 3, mul failed");
        #10
        // 4: 3 >> 1 = 1
        operation_select = 3'b101;
        operand1 = 3;
        operand2 = 1;
        #10
        assert (result == 1) else $error("Test 4, shr failed"); 
        #10
        // 5: 3 << 2 = 12
        operation_select = 3'b110;
        operand1 = 3;
        operand2 = 2;
        #10
        assert (result == 12) else $error("Test 5, shl failed");
        #10
        // 6: 3 ^ 2 = 1 
        operation_select = 3'b001;
        operand1 = 3;
        operand2 = 2;
        #10
        assert (result == 1) else $error("Test 6, xor failed");
        #10
        // 7: 0 - 0 : zero flag
        operation_select = 3'b011;
        operand1 = 0;
        operand2 = 0;
        #10
        assert (zero_flag == 1) else $error("Test 7, zero flag failed");
        #10
        // 8: 1 - 3: neg flag
        operand1 = 1;
        operand2 = 3;
        #10
        assert (neg_flag == 1) else $error("Test 8, neg flag failed");
        #20
        $finish;
    end


endmodule