
/*
# Team ID:          2401
# Theme:            MazeSolver Bot (MB)
# Author List:      Dibyendu Maity,Ankit Dwibedi,Sankalpa Basak,Snehajit Paul
# Filename:         adder.v
# File Description: A simple parameterized N-bit adder module 
# Global variables: None 
*/

module adder #(parameter WIDTH = 32 /* WIDTH: Sets the bit-width of the adder and its ports*/) (
    input       [WIDTH-1:0] a, b,
    output      [WIDTH-1:0] sum
);
// a: First input operand for addition
// b: Second input operand for addition
// sum: Output sum (a + b)

assign sum = a + b;

endmodule

