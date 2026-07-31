// =============================================================================
// Team ID    : 2401
// Theme      : MazeSolver Bot (MB)
// Authors    : Dibyendu Maity (not.dibyendu@gmail.com) and teams
// Filename   : frequency_scaling.v
// License    : MIT License (See LICENSE file in project root)
// =============================================================================
//
// Module Name : frequency_scaling
//
// Description : Clock divider: 50MHz → 3.125MHz (divide by 16).
//               Uses a 3-bit counter to toggle the output every 8 input clock
//               cycles, producing a 3.125MHz clock from the 50MHz system clock.
//
// Dependencies: None
// Target EDA  : Iverilog, GTKWave, Intel Quartus Prime, ModelSim
// Target HW   : Simulation / FPGA (Cyclone IV EP4CE22F17C6)
//
// Inputs      :
//   - clk_50M       : 50 MHz system clock input
//
// Outputs     :
//   - clk_3125KHz   : 3.125 MHz divided clock output
// =============================================================================

module frequency_scaling (
    input clk_50M,
    output reg clk_3125KHz
);

// clk_50M: Input, the 50MHz system clock
// clk_3125KHz: Output, the scaled-down clock signal

initial begin
    clk_3125KHz = 0;
end
//////////////////DO NOT MAKE ANY CHANGES ABOVE THIS LINE //////////////////
// counter: 3-bit register used to count input clock cycles for division
reg [2:0] counter = 0;

always @ (posedge clk_50M) begin
    /*
    Purpose:
    ---
    This block divides the input clock frequency. It uses a 3-bit counter 
    that counts from 0 to 7. The output clock is toggled every time the 
    counter rolls over to 0 (once every 8 input clock cycles). This results 
    in an output clock period that is 16 times the input clock period 
    (50MHz / 16 = 3.125MHz).
    */
    if (!counter) 
		clk_3125KHz <= ~clk_3125KHz; 
    counter <= counter + 1'b1; 
end
/*
Add your logic here
*/

//////////////////DO NOT MAKE ANY CHANGES BELOW THIS LINE //////////////////

endmodule
