/*
# Team ID:          2401
# Theme:            MazeSolver Bot (MB)
# Author List:      Dibyendu Maity,Ankit Dwibedi,Sankalpa Basak,Snehajit Paul
# Filename:         data_mem.v
# File Description: This module implements a simple synchronous-write, combinational-read data memory (RAM) for the CPU. It simulates a 64-word x 32-bit memory.
# Global variables: None
*/

module data_mem #(parameter DATA_WIDTH = 32,// DATA_WIDTH: The bit-width of each memory word
                            ADDR_WIDTH = 32,// ADDR_WIDTH: The bit-width of the address bus
                            MEM_SIZE = 64// MEM_SIZE: The number of words in the memory
) (
    input       clk, wr_en,
    input       [ADDR_WIDTH-1:0] wr_addr, wr_data,
    output      [DATA_WIDTH-1:0] rd_data_mem
);

// clk: Input, the system clock, used for synchronous writes
// wr_en: Input, write enable. If 1, data is written on the posedge clk
// wr_addr: Input, 32-bit address for read and write operations
// wr_data: Input, 32-bit data to be written to memory
// rd_data_mem: Output, 32-bit data read from the memory

// data_ram: The internal register array representing the memory storage
reg [DATA_WIDTH-1:0] data_ram [0:MEM_SIZE-1];

// combinational read logic
// This implements a word-aligned memory access.
// It discards the two least significant bits of the address (byte offset)
// and uses '% 64' to wrap the address around the 64-word memory size.
assign rd_data_mem = data_ram[wr_addr[DATA_WIDTH-1:2] % 64];

// synchronous write logic
always @(posedge clk) begin
    /*
    Purpose:
    ---
    This block performs a synchronous write to the memory. If write 
    enable (wr_en) is high, it writes the 'wr_data' into the memory 
    location specified by the word-aligned and wrapped address on the 
    positive edge of the clock.
    */
    if (wr_en) data_ram[wr_addr[DATA_WIDTH-1:2] % 64] <= wr_data;
end

endmodule

