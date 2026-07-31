// =============================================================================
// Team ID    : 2401
// Theme      : MazeSolver Bot (MB)
// Authors    : Dibyendu Maity (not.dibyendu@gmail.com) and teams
// Filename   : t2c_maze_explorer.v
// License    : MIT License (See LICENSE file in project root)
// =============================================================================
//
// Module Name : t2c_maze_explorer
//
// Description : Autonomous maze navigation controller.
//               Implements a depth-first search (DFS) based algorithm with
//               stack-based backtracking for junction handling. Takes three
//               wall sensors (left, mid, right) and outputs movement commands
//               (STOP, FORWARD, LEFT, RIGHT, U-TURN). Includes dead-end
//               detection and counting, visited-cell tracking, and exit
//               detection logic.
//
//               Note: This is not the most optimal search algorithm and
//               may not clear all testbench check cases.
//
// Dependencies: None
// Target EDA  : Iverilog, GTKWave, Intel Quartus Prime, ModelSim
// Target HW   : Simulation / FPGA (Cyclone IV EP4CE22F17C6)
//
// Inputs      :
//   - clk   : System clock
//   - rst_n : Active-low asynchronous reset
//   - left  : Left wall sensor (0 = no wall, 1 = wall)
//   - mid   : Middle wall sensor
//   - right : Right wall sensor
//
// Outputs     :
//   - move[2:0] : Movement command (000=STOP, 001=FORWARD, 010=LEFT,
//                 011=RIGHT, 100=U-TURN)
// =============================================================================

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

    // Parameters
    localparam STOP    = 3'b000;
    localparam FORWARD = 3'b001;
    localparam LEFT    = 3'b010;
    localparam RIGHT   = 3'b011;
    localparam UTURN   = 3'b100;

    // Absolute Directions
    localparam N = 2'b00; 
    localparam E = 2'b01; 
    localparam S = 2'b10; 
    localparam W = 2'b11;

    reg [6:0] position;
    reg [1:0] facing;
    reg [6:0] deadend_count;

    // Stack: Stores {Position(7), Tried_N, Tried_E, Tried_S, Tried_W} (11 bits)
    reg [10:0] stack [0:31]; 
    reg [4:0] sp;

    reg visited [0:80];
    integer i;

    // --- Helpers ---
    // Coordinate Map (TB Inverted Y: N=-9, S=+9)
    wire [6:0] pos_n = position - 7'd9;
    wire [6:0] pos_e = position + 7'd1;
    wire [6:0] pos_s = position + 7'd9;
    wire [6:0] pos_w = position - 7'd1;

    // Map Sensors to Absolute Directions
    reg s_n, s_e, s_s, s_w;
    always @(*) begin
        case(facing)
            N: begin s_n=mid; s_w=left; s_e=right; s_s=1; end
            E: begin s_e=mid; s_n=left; s_s=right; s_w=1; end
            S: begin s_s=mid; s_e=left; s_w=right; s_n=1; end
            W: begin s_w=mid; s_s=left; s_n=right; s_e=1; end
        endcase
    end

    // Valid Neighbors (Bounds + Walls + Start/Exit Safety)
    wire ok_n = !s_n && (pos_n < 81);
    wire ok_e = !s_e && (pos_e < 81);
    wire ok_s = !s_s && (pos_s < 81) && (position != 76); 
    wire ok_w = !s_w && (pos_w < 81);

    // Count Open Paths
    wire [2:0] abs_open_count = {2'b0, ok_n} + {2'b0, ok_e} + {2'b0, ok_s} + {2'b0, ok_w};

    // Next Position Logic (For sequential update)
    reg [6:0] next_pos;
    reg [1:0] next_facing;
    reg [3:0] new_tried;
    reg tried_n, tried_e, tried_s, tried_w;
    always @(*) begin
        next_facing = facing;
        next_pos = position;
        case(move)
            FORWARD: begin
                if(facing==N) next_pos=pos_n; else if(facing==E) next_pos=pos_e;
                else if(facing==S) next_pos=pos_s; else next_pos=pos_w;
            end
            LEFT: begin
                next_facing = (facing==N)?W:(facing-1);
                if(facing==N) next_pos=pos_w; else if(facing==E) next_pos=pos_n;
                else if(facing==S) next_pos=pos_e; else next_pos=pos_s;
            end
            RIGHT: begin
                next_facing = (facing==W)?N:(facing+1);
                if(facing==N) next_pos=pos_e; else if(facing==E) next_pos=pos_s;
                else if(facing==S) next_pos=pos_w; else next_pos=pos_n;
            end
            UTURN: begin
                next_facing = (facing+2);
                if(facing==N) next_pos=pos_s; else if(facing==E) next_pos=pos_w;
                else if(facing==S) next_pos=pos_n; else next_pos=pos_e;
            end
        endcase
    end
    
    wire next_valid = (next_pos < 81) && !(position==76 && next_pos >= 81);
    wire at_stack_top = (sp > 0) && (position == stack[sp-1][10:4]);

    // --- Main FSM ---
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            position <= 76; facing <= N; deadend_count <= 0; sp <= 0; move <= FORWARD;
            for(i=0; i<81; i=i+1) visited[i] <= 0; 
            visited[76] <= 1;
        end else begin
            
            // --- DECISION LOGIC ---
            
            // 1. Exit Logic
            if (position == 4 && facing == N && !mid) begin
                 if (deadend_count >= 6) move <= FORWARD; else move <= UTURN;
            end
            // 2. Dead End
            else if (left && mid && right) begin
                move <= UTURN;
                deadend_count <= deadend_count + 1;
            end
            // 3. Back at Saved Junction
            else if (at_stack_top) begin
                // Read Absolute Tried Flags
                
                tried_n = stack[sp-1][3]; tried_e = stack[sp-1][2];
                tried_s = stack[sp-1][1]; tried_w = stack[sp-1][0];
                
                // Pick untaken path (Priority N > E > S > W)
                if (ok_n && !tried_n) begin
                    stack[sp-1][3] <= 1; // Mark N tried
                    if(facing==N) move<=FORWARD; else if(facing==E) move<=LEFT; else if(facing==W) move<=RIGHT; else move<=UTURN;
                end
                else if (ok_e && !tried_e) begin
                    stack[sp-1][2] <= 1;
                    if(facing==E) move<=FORWARD; else if(facing==S) move<=LEFT; else if(facing==N) move<=RIGHT; else move<=UTURN;
                end
                else if (ok_s && !tried_s) begin
                    stack[sp-1][1] <= 1;
                    if(facing==S) move<=FORWARD; else if(facing==W) move<=LEFT; else if(facing==E) move<=RIGHT; else move<=UTURN;
                end
                else if (ok_w && !tried_w) begin
                    stack[sp-1][0] <= 1;
                    if(facing==W) move<=FORWARD; else if(facing==N) move<=LEFT; else if(facing==S) move<=RIGHT; else move<=UTURN;
                end
                else begin
                    // All paths tried -> Pop
                    sp <= sp - 1;
                    // Treat as corridor
                    if (!mid) move <= FORWARD; else if (!left) move <= LEFT; else move <= RIGHT;
                end
            end
            // 4. New Junction (Push to Stack)
            else if (abs_open_count > 1 && !visited[position]) begin
                  new_tried = 0; // N E S W
                 
                 // Determine chosen move (F > L > R)
                 if (!mid) begin 
                     move <= FORWARD;
                     // Mark chosen abs direction as tried
                     if(facing==N) new_tried[3]=1; else if(facing==E) new_tried[2]=1; else if(facing==S) new_tried[1]=1; else new_tried[0]=1;
                 end
                 else if (!left) begin 
                     move <= LEFT;
                     if(facing==N) new_tried[0]=1; else if(facing==E) new_tried[3]=1; else if(facing==S) new_tried[2]=1; else new_tried[1]=1;
                 end
                 else begin 
                     move <= RIGHT;
                     if(facing==N) new_tried[2]=1; else if(facing==E) new_tried[1]=1; else if(facing==S) new_tried[0]=1; else new_tried[3]=1;
                 end
                 
                 // Mark the direction we CAME FROM as tried (so we don't go back)
                 if(facing==N) new_tried[1]=1; // Came from S
                 else if(facing==E) new_tried[0]=1; // Came from W
                 else if(facing==S) new_tried[3]=1; // Came from N
                 else new_tried[2]=1; // Came from E
                 
                 // Clean Push: Calc mask combinatorially, then write once.
                 stack[sp] <= {position, new_tried};
                 sp <= sp + 1;
            end
            // 5. Corridor
            else begin
                if (!mid) move <= FORWARD;
                else if (!left) move <= LEFT;
                else move <= RIGHT;
            end
            
            // --- EXECUTE ---
            if (next_valid) begin
                position <= next_pos;
                facing <= next_facing;
                visited[next_pos] <= 1;
            end else begin
                 facing <= next_facing; 
            end
        end
    end

//////////////////DO NOT MAKE ANY CHANGES BELOW THIS LINE //////////////////

endmodule