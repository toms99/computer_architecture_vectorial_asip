module register #
(
    parameter N = 8 // default register size is 8
)
(
    input clk,
    input reset,
    input [N-1:0] data_in,
    output [N-1:0] data_out
);

    reg [N-1:0] my_register; // declare a N-bit register

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            my_register <= 0; // reset the register to 0
        end
        else begin
            my_register <= data_in; // update the register with input data
        end
    end

    assign data_out = my_register; // assign register value to output

endmodule
