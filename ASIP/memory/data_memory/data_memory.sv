module data_memory(input logic clk, write_enable,
						input logic [31:0] DataAdr, toWrite_data,
						output logic [31:0] read_data, output logic [31:0] RAM[703:0]);

				
				
	initial begin
		$readmemh("RAM.txt", RAM);
		for (int i = 0; i < 704 ; i++) begin
			RAM[i] = 32'b0;
		end
	end

	always_ff @(negedge clk) begin
		read_data = {24'b0, RAM[DataAdr[31:2]]} ; // Alineamiento de la palabra
	end

	always_ff @(posedge clk) begin
		if (write_enable) RAM[DataAdr[31:2]] <= toWrite_data;
		$writememh("RAM.txt",RAM);
	end
					
endmodule