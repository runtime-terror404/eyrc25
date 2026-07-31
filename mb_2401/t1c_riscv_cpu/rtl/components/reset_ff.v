// =============================================================================
// Team ID    : 2401
// Theme      : MazeSolver Bot (MB)
// Authors    : Dibyendu Maity (not.dibyendu@gmail.com) and teams
// Filename   : reset_ff.v
// License    : MIT License (See LICENSE file in project root)
// =============================================================================
//
// Module Name : reset_ff
//
// Description : Parameterized N-bit D flip-flop with active-high synchronous
//               reset. Used for pipeline registers and PC.
//
// Dependencies: None
// Target EDA  : Iverilog, GTKWave, Intel Quartus Prime, ModelSim
// Target HW   : Simulation / FPGA (Cyclone IV EP4CE22F17C6)
// =============================================================================

module reset_ff #(parameter WIDTH = 8 // WIDTH: Sets the bit-width of the flip-flop's data ports (d and q)
) (
    input       clk, rst,
    input       [WIDTH-1:0] d,
    output reg  [WIDTH-1:0] q
);
// clk: Input, the system clock signal
// rst: Input, active-high synchronous reset. When high, q is forced to 0.
// d: Input, the data to be loaded into the flip-flop
// q: Output, the stored value of the flip-flop

always @(posedge clk or posedge rst) begin
    /*
    Purpose:
    ---
    This block describes the behavior of a synchronous D flip-flop with an 
    active-high reset. On the positive edge of the clock or reset, it 
    checks the reset signal first. If reset is active (high), the output 'q' 
    is cleared to 0. Otherwise, the output 'q' captures the value of the 
    input 'd'.
    */
    
    if (rst) q <= 0;
    else     q <= d;
end

endmodule

