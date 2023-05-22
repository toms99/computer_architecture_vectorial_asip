module vector_extender #(parameter vectorSize = 4, parameter dataSize = 16) (
    input [dataSize-1:0] inData,
    output [vectorSize-1:0] [dataSize-1:0] outData
);
    generate
        genvar i;
        for (i = 0; i < vectorSize; i = i + 1) begin : VECTOR_BLOCK
            assign outData[i] = inData;
        end
    endgenerate
endmodule