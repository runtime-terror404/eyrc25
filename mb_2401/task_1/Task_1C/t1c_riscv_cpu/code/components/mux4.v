/*
# Team ID:          2401
# Theme:            MazeSolver Bot (MB)
# Author List:      Dibyendu Maity,Ankit Dwibedi,Sankalpa Basak,Snehajit Paul
# Filename:         mux4.v
# File Description: A parameterized N-bit 4-to-1 multiplexer.
# Global variables: None
*/


module mux4 #(parameter WIDTH = 8 // WIDTH: Sets the bit-width of the data inputs and output
) (
    input       [WIDTH-1:0] d0, d1, d2, d3,
    input       [1:0] sel,
    output      [WIDTH-1:0] y
);
// d0: Input data line 0 (selected when sel=2'b00)
// d1: Input data line 1 (selected when sel=2'b01)
// d2: Input data line 2 (selected when sel=2'b10)
// d3: Input data line 3 (selected when sel=2'b11)
// sel: 2-bit select line
// y: Output, selected data (d0, d1, d2, or d3)

assign y = sel[1] ? (sel[0] ? d3 : d2) : (sel[0] ? d1 : d0);

endmodule

