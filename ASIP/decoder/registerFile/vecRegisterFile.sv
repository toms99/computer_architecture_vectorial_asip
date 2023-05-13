module vecRegisterFile #(
    parameter registerSize = 8,
    parameter registerQuantity = 8
) (
    input clk, reset,

    input regWrEn,
    input [2:0] rSel1, rSel2, regToWrite,

    input [registerSize-1:0] regWriteData_0,
    input [registerSize-1:0] regWriteData_1,
    input [registerSize-1:0] regWriteData_2,
    input [registerSize-1:0] regWriteData_3,

    output [registerSize-1:0] reg1Out_0,
    output [registerSize-1:0] reg1Out_1,
    output [registerSize-1:0] reg1Out_2,
    output [registerSize-1:0] reg1Out_3,

    output [registerSize-1:0] reg2Out_0,
    output [registerSize-1:0] reg2Out_1,
    output [registerSize-1:0] reg2Out_2,
    output [registerSize-1:0] reg2Out_3
);
    logic [registerQuantity-1:0] reg_N_WrEn;
    logic [registerQuantity-1:0] [registerSize-1:0] reg_N_Out_0;
    logic [registerQuantity-1:0] [registerSize-1:0] reg_N_Out_1;
    logic [registerQuantity-1:0] [registerSize-1:0] reg_N_Out_2;
    logic [registerQuantity-1:0] [registerSize-1:0] reg_N_Out_3;

    logic_decoder #(.in(3), .out(registerQuantity)) regWrDecoder(
        .sel(regToWrite), .data_out(reg_N_WrEn)
    );

    generate
        genvar i;
        for (i = 0; i < registerQuantity; i = i + 1) begin: REGISTER_BLOCK
            register #(registerSize) r_0 (
                .clk(clk & reg_N_WrEn[i] & regWrEn), .reset(reset),
                .data_in(regWriteData_0), .data_out(reg_N_Out_0[i])
            );
            register #(registerSize) r_1 (
                .clk(clk & reg_N_WrEn[i] & regWrEn), .reset(reset),
                .data_in(regWriteData_1), .data_out(reg_N_Out_1[i])
            );
            register #(registerSize) r_2 (
                .clk(clk & reg_N_WrEn[i] & regWrEn), .reset(reset),
                .data_in(regWriteData_2), .data_out(reg_N_Out_2[i])
            );
            register #(registerSize) r_3 (
                .clk(clk & reg_N_WrEn[i] & regWrEn), .reset(reset),
                .data_in(regWriteData_3), .data_out(reg_N_Out_3[i])
            );
        end
    endgenerate

    assign reg1Out_0 = reg_N_Out_0[rSel1];
    assign reg1Out_1 = reg_N_Out_1[rSel1];
    assign reg1Out_2 = reg_N_Out_2[rSel1];
    assign reg1Out_3 = reg_N_Out_3[rSel1];

    assign reg2Out_0 = reg_N_Out_0[rSel2];
    assign reg2Out_1 = reg_N_Out_1[rSel2];
    assign reg2Out_2 = reg_N_Out_2[rSel2];
    assign reg2Out_3 = reg_N_Out_3[rSel2];

endmodule