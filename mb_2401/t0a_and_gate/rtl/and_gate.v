// =============================================================================
// Team ID    : 2401
// Theme      : MazeSolver Bot (MB)
// Authors    : Dibyendu Maity (not.dibyendu@gmail.com) and teams
// Filename   : and_gate.v
// License    : MIT License (See LICENSE file in project root)
// =============================================================================
//
// Module Name : and_gate
//
// Description : 2-input AND gate.
//               Implements basic logical AND operation: out = a & b.
//
// Dependencies: None
// Target EDA  : Iverilog, GTKWave, Intel Quartus Prime, ModelSim
// Target HW   : Simulation / FPGA (Cyclone IV EP4CE22F17C6)
//
// Inputs      :
//   - a   : First input
//   - b   : Second input
//
// Outputs     :
//   - out : AND result of inputs a and b
// =============================================================================

module and_gate (
    input a,b,          // defining inputs A and B of AND gate
    output out          // defining output of AND gate
);

assign out = a & b;     // Logic implementation

endmodule
