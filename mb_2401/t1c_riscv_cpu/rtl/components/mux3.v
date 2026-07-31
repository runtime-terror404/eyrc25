// =============================================================================
// Team ID    : 2401
// Theme      : MazeSolver Bot (MB)
// Authors    : Dibyendu Maity (not.dibyendu@gmail.com) and teams
// Filename   : mux3.v
// License    : MIT License (See LICENSE file in project root)
// =============================================================================
//
// Module Name : mux3
//
// Description : Parameterized N-bit 3-to-1 multiplexer.
//               y = sel[1] ? d2 : (sel[0] ? d1 : d0)
//
// Dependencies: None
// Target EDA  : Iverilog, GTKWave, Intel Quartus Prime, ModelSim
// Target HW   : Simulation / FPGA (Cyclone IV EP4CE22F17C6)
// =============================================================================

module mux3 #(parameter WIDTH = 8 // WIDTH: Sets the bit-width of the data inputs and output
) (
    input       [WIDTH-1:0] d0, d1, d2,
    input       [1:0] sel,
    output      [WIDTH-1:0] y
);

// d0: Input data line 0 (selected when sel=2'b00)
// d1: Input data line 1 (selected when sel=2'b01)
// d2: Input data line 2 (selected when sel=2'b10 or 2'b11)
// sel: 2-bit select line
// y: Output, selected data (d0, d1, or d2)

// Logic: if sel[1] is 1, output d2. 
// Otherwise (if sel[1] is 0), if sel[0] is 1, output d1, else output d0.

assign y = sel[1] ? d2: (sel[0] ? d1 : d0);

endmodule

