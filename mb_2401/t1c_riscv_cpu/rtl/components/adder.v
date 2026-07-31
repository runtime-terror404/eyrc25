
// =============================================================================
// Team ID    : 2401
// Theme      : MazeSolver Bot (MB)
// Authors    : Dibyendu Maity (not.dibyendu@gmail.com) and teams
// Filename   : adder.v
// License    : MIT License (See LICENSE file in project root)
// =============================================================================
//
// Module Name : adder
//
// Description : Parameterized N-bit adder. Computes sum = a + b.
//
// Dependencies: None
// Target EDA  : Iverilog, GTKWave, Intel Quartus Prime, ModelSim
// Target HW   : Simulation / FPGA (Cyclone IV EP4CE22F17C6)
// =============================================================================

module adder #(parameter WIDTH = 32 /* WIDTH: Sets the bit-width of the adder and its ports*/) (
    input       [WIDTH-1:0] a, b,
    output      [WIDTH-1:0] sum
);
// a: First input operand for addition
// b: Second input operand for addition
// sum: Output sum (a + b)

assign sum = a + b;

endmodule

