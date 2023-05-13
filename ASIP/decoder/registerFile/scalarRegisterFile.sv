// Register Quantity has to be a power of 2
module scalarRegisterFile #(
    parameter registerSize=8, 
    parameter registerQuantity=4,
    parameter selectionBits=3
) (
    input clk, reset,
    input regWrEn,
    input [selectionBits-1:0] rSel1, rSel2, regToWrite,
    input [registerSize-1:0] dataIn,
    output [registerSize-1:0] reg1Out, reg2Out
);
    logic [registerQuantity-1:0] reg_N_WrEn;
    logic [registerQuantity-1:0] [registerSize-1:0] reg_N_Out;

    logic_decoder #(.in(selectionBits), .out(registerQuantity)) regWrDecoder(
        .sel(regToWrite), .data_out(reg_N_WrEn)
    );

    generate
        genvar i;
        for (i = 0; i < registerQuantity; i = i + 1) begin: REGISTER_BLOCK
            register #(registerSize) r (
                .clk(clk & reg_N_WrEn[i] & regWrEn), .reset(reset),
                .data_in(dataIn), .data_out(reg_N_Out[i])
            );
        end
    endgenerate

    assign reg1Out = reg_N_Out[rSel1];
    assign reg2Out = reg_N_Out[rSel2];

endmodule