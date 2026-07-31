// =============================================================================
// Team ID    : 2401
// Theme      : MazeSolver Bot (MB)
// Authors    : Dibyendu Maity (not.dibyendu@gmail.com) and teams
// Filename   : full_adder.v
// License    : MIT License (See LICENSE file in project root)
// =============================================================================
//
// Module Name : full_adder
//
// Description : 1-bit full adder with carry in and carry out.
//               sum = a ^ b ^ c_in
//               c_out = ((a ^ b) & c_in) | (a & b)
//
// Dependencies: None
// Target EDA  : Iverilog, GTKWave, Intel Quartus Prime, ModelSim
// Target HW   : Simulation / FPGA (Cyclone IV EP4CE22F17C6)
//
// Inputs      :
//   - a    : First input bit
//   - b    : Second input bit
//   - c_in : Carry input
//
// Outputs     :
//   - sum   : Sum output (a + b + c_in)
//   - c_out : Carry output
// =============================================================================

module full_adder (
    input a, b, c_in, // Define input ports a, b and c_in
    output sum , c_out // Define output ports sum and c_out
);

assign sum = a^b^c_in; // Define Sum logic
assign c_out = ((a^b)&c_in)|(a&b); // Define Carry_out logic

endmodule
