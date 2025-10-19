
/*
# Team ID:          2401
# Theme:            MazeSolver Bot (MB)
# Author List:      Dibyendu Maity,Ankit Dwibedi,Sankalpa Basak,Snehajit Paul
# Filename:         mux2.v
# File Description: A parameterized N-bit 2-to-1 multiplexer.
# Global variables: None
*/

module mux2 #(parameter WIDTH = 8) // WIDTH: Sets the bit-width of the data inputs and output
(
    input       [WIDTH-1:0] d0, d1,
    input       sel,
    output      [WIDTH-1:0] y
);
// d0: Input data line 0
// d1: Input data line 1
// sel: Select line (if 0, y=d0; if 1, y=d1)
// y: Output, selected data (d0 or d1)

assign y = sel ? d1 : d0;

endmodule

