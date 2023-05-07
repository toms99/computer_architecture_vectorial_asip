module instruction_memory (input logic [31:0] address,
             output logic [31:0] rdata);

    logic [31:0] ROM[255:0];

    initial begin
        $readmemh("ROM.txt",ROM);
    end
    assign rdata = ROM[address[31:2]]; // Palabra alineada

endmodule