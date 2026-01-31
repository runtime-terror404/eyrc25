/*
# Team ID:          2401
# Theme:            MazeSolver Bot (MB)
# Author List:      Dibyendu Maity, Ankit Dwibedi, Sankalpa Basak, Snehajit Paul
# Filename:         t2c_maze_explorer.v
# File Description: This module implements the autonomous navigation logic for the MazeSolver Bot. It uses a simple "left-wall-following" algorithm to make movement decisions based on sensor inputs.
# Global variables: None
*/

// Task 2C - MazeSolver Bot

/*
Module Maze Explorer

This module implements the core decision-making logic for navigating the maze.
It takes inputs from three wall sensors (left, middle, right) and outputs a
3-bit movement command based on a left-wall-following algorithm.

Input:  clk     - System clock
        rst_n   - Active-low asynchronous reset
        left    - Left wall sensor (0 = no wall, 1 = wall)
        mid     - Middle wall sensor (0 = no wall, 1 = wall)
        right   - Right wall sensor (0 = no wall, 1 = wall)

Output: move    - 3-bit movement command (see parameter definitions)
*/

module t2c_maze_explorer (
    input clk,
    input rst_n,
    input left, mid, right, // 0 - no wall, 1 - wall
    output reg [2:0] move
);

/*

| cmd | move  | meaning   |
|-----|-------|-----------|
| 000 | 0     | STOP      |
| 001 | 1     | FORWARD   |
| 010 | 2     | LEFT      |
| 011 | 3     | RIGHT     | 
| 100 | 4     | U_TURN    |

START POS   : 4,0
EXIT POS    : 4,8
DEADENDS    : 9

*/
//////////////////DO NOT MAKE ANY CHANGES ABOVE THIS LINE //////////////////


// Movement commands
parameter STOP    = 3'b000; // STOP: Command to stop motors
parameter FORWARD = 3'b001; // FORWARD: Command to move forward one cell
parameter LEFT    = 3'b010; // LEFT: Command to turn left 90 degrees
parameter RIGHT   = 3'b011; // RIGHT: Command to turn right 90 degrees
parameter U_TURN  = 3'b100; // U_TURN: Command to turn 180 degrees

// Simple Left-Wall Follower
always @(posedge clk or negedge rst_n) begin
    /*
    Purpose:
    ---
    This block implements the synchronous logic for the left-wall-following
    algorithm. On active-low reset, the bot is commanded to STOP.
    On each clock edge, it checks sensors in this priority:
    1. Is there no wall on the left? -> Turn LEFT.
    2. Is the left blocked, but the middle open? -> Go FORWARD.
    3. Are left and middle blocked, but right is open? -> Turn RIGHT.
    4. Are all paths blocked? -> Perform a U_TURN.
    */
    if (!rst_n) begin
        move <= STOP;
    end else begin
        // Left-wall follower logic
        if (left == 1'b0) begin
            move <= LEFT;      // Always try to go left first
        end else if (mid == 1'b0) begin
            move <= FORWARD;   // If left blocked, go forward
        end else if (right == 1'b0) begin
            move <= RIGHT;     // If forward blocked, go right
        end else begin
            move <= U_TURN;    // If all blocked, turn around
        end
    end
end



//////////////////DO NOT MAKE ANY CHANGES BELOW THIS LINE //////////////////

endmodule