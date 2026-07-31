// =============================================================================
// Team ID    : 2401
// Theme      : MazeSolver Bot (MB)
// Authors    : Dibyendu Maity (not.dibyendu@gmail.com) and teams
// Filename   : ripple_carry_adder.v
// License    : MIT License (See LICENSE file in project root)
// =============================================================================
//
// Module Name : ripple_carry_adder
//
// Description : 2-bit ripple carry adder.
//               Cascades two 1-bit full_adder modules to add two 2-bit numbers
//               with carry propagation from LSB to MSB.
//
// Dependencies: full_adder.v
// Target EDA  : Iverilog, GTKWave, Intel Quartus Prime, ModelSim
// Target HW   : Simulation / FPGA (Cyclone IV EP4CE22F17C6)
//
// Inputs      :
//   - a[1:0] : 2-bit first operand
//   - b[1:0] : 2-bit second operand
//   - cin    : Carry input
//
// Outputs     :
//   - sum[1:0] : 2-bit sum result
//   - c_out    : Carry output (MSB overflow)
// =============================================================================

module ripple_carry_adder (
    input [1:0] a, b,
    input cin, // Define all input ports
    output [1:0] sum,
    output c_out // Define all output ports
);
wire c1; // Define intermediate carry as c1

full_adder FA0 (a[0], b[0], cin, sum[0], c1); // instantiate full_adder (FA0)
full_adder FA1 (a[1], b[1], c1, sum[1], c_out); // instantiate full_adder (FA1)

endmodule
