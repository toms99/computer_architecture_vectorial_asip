module data_memory #(
    parameter dataSize = 32,
    parameter addressingSize = 32,
    parameter memorySize = 704,
    parameter vecSize = 4
) (
    input logic clk, write_enable,
    input logic [addressingSize-1:0] DataAdr,
    input logic [vecSize-1:0] [dataSize-1:0] toWrite_data,
    output logic [vecSize-1:0] [dataSize-1:0] read_data
);
    parameter bytes_in_addr = dataSize / 8;
    parameter bits_to_address_bytes_in_addr = $clog2(bytes_in_addr);

    logic [dataSize-1:0] RAM [memorySize-1:0];
	initial begin
		$readmemh("RAM.txt", RAM);
		/*for (int i = 0; i < memorySize ; i++) begin
			RAM[i] = 'b0;
		end*/
	end
    
    always_ff @(posedge clk) begin
        if (write_enable) begin 
            for (int i = 0; i < vecSize; i = i + 1)
                RAM[DataAdr[addressingSize-1:bits_to_address_bytes_in_addr] +
                    i * bytes_in_addr] <= toWrite_data[i];
        end else begin 
            for (int i = 0; i < vecSize; i = i + 1)
                read_data[i] <= 
                    RAM[DataAdr[addressingSize-1:
                                bits_to_address_bytes_in_addr] + i * bytes_in_addr];
        end
    end
	 
	 always_ff @(negedge clk)begin
		 if (write_enable) begin 
			$writememh("RAM.txt",RAM);
		 end
	 end
endmodule