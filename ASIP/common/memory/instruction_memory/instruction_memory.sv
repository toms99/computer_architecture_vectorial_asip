module instruction_memory (input logic [7:0] address,
             output logic [15:0] rdata);

    logic [15:0] ROM[255:0];

    initial begin
        // This route has to be absolute...
        $readmemh("ROM.txt",ROM);
    end
    assign rdata = ROM[address[7:2]]; // Palabra alineada

endmodule