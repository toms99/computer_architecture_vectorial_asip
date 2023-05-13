module regFile #(
    parameter registerSize = 8,
    parameter registerQuantity = 8,
    parameter vecSize = 4)
(
    input clk, reset,
    input regWrEnSc, regWrEnVec,
    input [3:0] rSel1, rSel2,
    input [2:0] regToWrite,
    input [vecSize-1:0] [registerSize-1:0] dataIn, operand1, operand2
);

    logic [registerSize-1:0] scalar_reg1Out, scalar_reg2Out;

    scalarRegisterFile #(registerSize, registerQuantity) scalarRegisters(
        .clk(clk), .reset(reset),
        .regWrEn(regWrEnSc), .rSel1(rSel1), .rSel2(rSel2),
        .regToWrite(regToWrite), .dataIn(dataIn[0]), // For scalars we will just take in consideration the first element
        .reg1Out(scalar_reg1Out), reg2Out(scalar_reg2Out)
    );

    vecRegisterFile #(registerSize, registerQuantity) (
        .clk(clk), .reset(reset),
        .regWrEn(regWrEnVec), .rSel1(rSel1), .rSel2(rSel2), 
        .regToWrite(regToWrite),
    );



endmodule