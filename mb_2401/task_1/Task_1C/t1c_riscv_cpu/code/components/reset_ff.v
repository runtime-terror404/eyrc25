/*
# Team ID:          2401
# Theme:            MazeSolver Bot (MB)
# Author List:      Dibyendu Maity,Ankit Dwibedi,Sankalpa Basak,Snehajit Paul
# Filename:         reset_ff.v
# File Description: A parameterized N-bit wide D flip-flop with a synchronous active-high reset.
# Global variables: None
*/

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

