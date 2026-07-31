// =============================================================================
// Team ID    : 2401
// Theme      : MazeSolver Bot (MB)
// Authors    : Dibyendu Maity (not.dibyendu@gmail.com) and teams
// Filename   : mux2.v
// License    : MIT License (See LICENSE file in project root)
// =============================================================================
//
// Module Name : mux2
//
// Description : Parameterized N-bit 2-to-1 multiplexer.
//               y = sel ? d1 : d0
//
// Dependencies: None
// Target EDA  : Iverilog, GTKWave, Intel Quartus Prime, ModelSim
// Target HW   : Simulation / FPGA (Cyclone IV EP4CE22F17C6)
// =============================================================================

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

