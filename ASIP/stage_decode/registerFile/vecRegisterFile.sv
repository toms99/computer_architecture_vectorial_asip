module vecRegisterFile #(
    parameter registerSize = 16,
    parameter registerQuantity = 4,
    parameter selectionBits = 2,
    parameter vectorSize = 4
) (
    input clk, reset,
    input regWrEn,
    input [selectionBits-1:0] rSel1, rSel2, regToWrite,
    input [vectorSize-1:0] [registerSize-1:0] regWriteData,
    output [vectorSize-1:0] [registerSize-1:0] reg1Out,
    output [vectorSize-1:0] [registerSize-1:0] reg2Out
);
    logic [registerQuantity-1:0] reg_N_WrEn;
    logic [registerQuantity-1:0] [vectorSize-1:0] [registerSize-1:0] reg_N_Out;

    logic_decoder #(.in(selectionBits), .out(registerQuantity)) regWrDecoder(
        .sel(regToWrite), .data_out(reg_N_WrEn)
    );

    generate
        genvar j;
        genvar i;
        for (j = 0; j < vectorSize; j = j + 1) begin: VECTOR_BLOCK
            for (i = 0; i < registerQuantity; i = i + 1) begin: REGISTER_BLOCK
                register #(registerSize) r (
                    .clk(clk & reg_N_WrEn[i] & regWrEn), .reset(reset),
                    .data_in(regWriteData[j]), .data_out(reg_N_Out[i][j])
                );
            end
        end
    endgenerate


    generate
        genvar k;
        for (k = 0; k < vectorSize; k = k + 1) begin: OUT_VECTOR_BLOCK
            assign reg1Out[k] = reg_N_Out[rSel1][k];
            assign reg2Out[k] = reg_N_Out[rSel2][k];
        end
    endgenerate

endmodule