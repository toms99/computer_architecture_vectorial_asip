module data_memory #(
    parameter dataSize = 32,
    parameter addressingSize = 32,
    parameter memorySize = 10020,
    parameter vecSize = 4
) (
    input logic clk, write_enable,
    input logic [addressingSize-1:0] DataAdr,
    input [5:0] mode,
    input logic [vecSize-1:0] [dataSize-1:0] toWrite_data,
    output logic [vecSize-1:0] [dataSize-1:0] read_data
);
    parameter bytes_in_addr = dataSize / 8;
    parameter bits_to_address_bytes_in_addr = $clog2(bytes_in_addr);

    logic [7:0] RAM [memorySize-1:0];
	initial begin
		$readmemb("RAM.txt", RAM);
	end
    
    always_ff @(posedge clk) begin
        if (write_enable) begin 
            for (int i = 0; i < vecSize; i = i + 1) begin
                for (int j = 0; j < bytes_in_addr; j = j + 1)
                    RAM[DataAdr[addressingSize-1:bits_to_address_bytes_in_addr] +
                        i * bytes_in_addr + j] <=
                        toWrite_data[i][j*8 +: 8];
            end
        end else begin 
            for (int i = 0; i < vecSize; i = i + 1) begin
                for (int j = 0; j < bytes_in_addr; j = j + 1)
                    read_data[i][j*8 +: 8] <= 
                        RAM[DataAdr[addressingSize-1:
                                    bits_to_address_bytes_in_addr] + 
                                    i * bytes_in_addr + j];
            end
        end
        RAM[10004] <= {2'b0, mode};
    end
	 
	 always_ff @(negedge clk)begin
		 if (write_enable) begin 
			$writememb("RAM.txt",RAM);
		 end
	 end
endmodule