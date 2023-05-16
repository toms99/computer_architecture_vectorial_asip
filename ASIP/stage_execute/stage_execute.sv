module stage_execute #(
	parameter registerSize = 8,
	parameter vectorSize = 4
)
(
	input logic clk, reset, PCWrEn, overwriteFlags,
    input logic [2:0] ExecuteOp,
	input logic [vectorSize-1:0] [registerSize-1:0] vect1, vect2,
	output logic [vectorSize-1:0] [registerSize-1:0] vect_out,
    output logic [1:0] NZ_flags
);

    logic [vectorSize-1:0] negativeFlags, zeroFlags;

    generate
        genvar i;
        for (i = 0; i < vectorSize; i = i + 1) begin : alu_block
            alu #(
                .dataSize(registerSize)
            ) alu (
                .operation_select(ExecuteOp), .operand1(vect1[i]),
                .operand2(vect2[i]), .result(vect_out[i]),
                .neg_flag(negativeFlags[i]), .zero_flag(zeroFlags[i])
            );
        end
    endgenerate
    
    register #(1) negative_flag_register (
        .clk(clk & overwriteFlags), .reset(reset),
        .data_in(|negativeFlags), .data_out(NZ_flags[0])
    );

    register #(1) zero_flag_register (
        .clk(clk & overwriteFlags), .reset(reset),
        .data_in(&zeroFlags), .data_out(NZ_flags[1])
    );

endmodule