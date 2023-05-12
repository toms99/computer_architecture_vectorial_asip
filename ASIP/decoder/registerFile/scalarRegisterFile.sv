// Register Quantity has to be a power of 2
module scalarRegisterFile #(parameter registerSize=8, parameter registerQuantity=8) (
    input clk, reset,
    input regWrEn,
    input [2:0] rSel1, rSel2,
    input [2:0] regToWrite,
    input [registerSize:0] dataIn,
    output [registerSize:0] reg1Out, reg2Out
);

    logic [registerQuantity:0] reg_N_WrEn;
    logic [registerQuantity:0] [registerSize-1:0] reg_N_Out;

    logic_decoder #(.in(3), .out(registerQuantity)) regWrDecoder(
        .sel(regToWrite), .data_out(reg_N_WrEn)
    );

    generate
        genvar i;
        for (i = 0; i < registerQuantity; i = i + 1) begin: REGISTER_BLOCK
            register #(registerSize-1) r (
                .clk(clk & reg_N_WrEn[i] & regWrEn), .reset(reset),
                .data_in(dataIn), .data_out(reg_N_Out[i])
            );
        end
    endgenerate

    assign reg1Out = reg_N_Out[rSel1];
    assign reg2Out = reg_N_Out[rSel2];

endmodule