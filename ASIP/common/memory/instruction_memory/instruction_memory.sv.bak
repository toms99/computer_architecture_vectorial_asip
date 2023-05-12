module instruction_memory (input logic [7:0] address,
             output logic [15:0] rdata);

    logic [15:0] ROM[255:0];

    initial begin
        // This route has to be absolute...
        $readmemh("C:/Users/kazeledo/Documentos/Universidad/IS2022/arqui/proyectos/arqui/computer_architecture_vectorial_asip/ASIP/common/memory/instruction_memory/ROM.txt",ROM);
    end
    assign rdata = ROM[address[7:2]]; // Palabra alineada

endmodule