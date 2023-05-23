module alu #(
    parameter dataSize = 8
) (
    input logic [2:0] operation_select,
    input logic [dataSize-1:0] operand1, operand2,
    output logic [dataSize-1:0] result,
    output logic neg_flag, zero_flag
);

    logic [dataSize-1:0] sum_res, sub_res, mult_res, rshift_res, lshift_res, 
        xor_res, inc_res;
    
    assign sum_res = operand1 + operand2;
    assign sub_res = operand1 - operand2;
    assign mult_res = operand1 * operand2;
	 assign rshift_res = (operand1 >> (operand2 % dataSize)) | (operand1 << (dataSize - (operand2 % dataSize)));
    assign lshift_res = (operand1 << (operand2 % dataSize)) | (operand1 >> (dataSize - (operand2 % dataSize)));
    assign xor_res = operand1 ^ operand2;
    assign inc_res = operand1 + 16;

    assign result = operation_select == 3'b001 ? xor_res :
                    operation_select == 3'b010 ? sum_res :
                    operation_select == 3'b011 ? sub_res :
                    operation_select == 3'b100 ? mult_res :
                    operation_select == 3'b101 ? rshift_res :
                    operation_select == 3'b110 ? lshift_res :
                    operation_select == 3'b111 ? inc_res :
                    3'b0;
    assign zero_flag = result == 0;
    assign neg_flag = (operand1[dataSize-1] != result[dataSize-1]) && !zero_flag;


endmodule