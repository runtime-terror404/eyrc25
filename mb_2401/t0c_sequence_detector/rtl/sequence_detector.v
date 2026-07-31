// =============================================================================
// Team ID    : 2401
// Theme      : MazeSolver Bot (MB)
// Authors    : Dibyendu Maity (not.dibyendu@gmail.com) and teams
// Filename   : sequence_detector.v
// License    : MIT License (See LICENSE file in project root)
// =============================================================================
//
// Module Name : sequence_detector
//
// Description : Sequence detector FSM that recognizes the pattern "1094"
//               (1→0→9→4) from a stream of 4-bit BCD digits.
//               Uses a 4-state Moore-style state machine.
//
// Dependencies: None
// Target EDA  : Iverilog, GTKWave, Intel Quartus Prime, ModelSim
// Target HW   : Simulation / FPGA (Cyclone IV EP4CE22F17C6)
//
// Inputs      :
//   - clock    : Clock input
//   - number[3:0] : 4-bit BCD digit input
//
// Outputs     :
//   - pattern  : Asserted high for one cycle when sequence "1094" detected
// =============================================================================

// Verilog code for Sequence Detector
    // Define Sequence Detector module
    module sequence_detector (
        input clock,
        input [3:0] number, // Define input ports clock, number
        output reg pattern // Define output port patter
    );


	 //////////////////////////////////////////////
    // Define your State Machine Parameters Here
    parameter ST_ONE = 0,ST_ZERO=1,ST_NINE=2,ST_FOUR=3;
	 //////////////////////////////////////////////

    // defining 2-bit register
    reg [1:0] state = ST_ONE;

    initial begin // define initial state output register
        pattern = 0;
    end

    always @(posedge clock) begin
        pattern = 0;
        case (state)
			   ///////////////////////////////////////
				// Do not modify above part of the code
            // Write your state machine here
				ST_ONE: begin
					// you can read input inside always block like this
					 if (number == 1) state = ST_ZERO;
					 else state = ST_ONE;
				end
				ST_ZERO: begin
					 if (number == 0) state = ST_NINE;
					 else state = ST_ONE;
				end
				ST_NINE: begin
					 if (number == 9) state = ST_FOUR;
					 else state = ST_ONE;
				end
				ST_FOUR: begin
					 if (number == 4) begin
                state = ST_ONE; pattern = 1;
					 end
					 else state = ST_ONE;
					 // Do not modify below part of the code
					 ///////////////////////////////////////
				end
        endcase
    end

    endmodule