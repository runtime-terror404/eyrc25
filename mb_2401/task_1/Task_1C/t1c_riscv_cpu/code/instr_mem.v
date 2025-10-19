/*
# Team ID:          2401
# Theme:            MazeSolver Bot (MB)
# Author List:      Dibyendu Maity,Ankit Dwibedi,Sankalpa Basak,Snehajit Paul
# Filename:         instr_mem.v
# File Description: Implements a combinational-read instruction memory (ROM). It is initialized from a hexadecimal file (rv32i_test.hex) at the start of simulation.
# Global variables: None
*/

module instr_mem #(parameter DATA_WIDTH = 32,// DATA_WIDTH: The bit-width of each instruction
                            ADDR_WIDTH = 32, // ADDR_WIDTH: The bit-width of the address bus
                            MEM_SIZE = 512// MEM_SIZE: The number of instruction words in the memory
) (
    input       [ADDR_WIDTH-1:0] instr_addr,
    output      [DATA_WIDTH-1:0] instr
);

// instr_addr: Input, 32-bit byte address from the Program Counter (PC)
// instr: Output, 32-bit instruction word read from the memory

// instr_ram: The internal register array representing the instruction memory storage
reg [DATA_WIDTH-1:0] instr_ram [0:MEM_SIZE-1];

initial begin
    /*
    Purpose:
    ---
    To initialize the instruction memory (instr_ram) by loading the 
    contents of a hexadecimal file ("rv32i_test.hex") at the 
    beginning of a simulation.
    */
    //$readmemh("rv32i_book.hex", instr_ram);
    $readmemh("rv32i_test.hex", instr_ram);
end

// word-aligned memory access
// combinational read logic
// The byte address (instr_addr) is converted to a word address by selecting bits [31:2]
assign instr = instr_ram[instr_addr[31:2]];

endmodule

