/*
# Team ID:          2401
# Theme:            MazeSolver Bot (MB)
# Author List:      Dibyendu Maity,Ankit Dwibedi,Sankalpa Basak,Snehajit Paul
# Filename:         frequency_scaling.v
# File Description: This module acts as a clock divider, scaling down the input 50MHz clock. The current logic divides the clock by 16 to produce a 3.125MHz output clock.
# Global variables: None
*/

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
