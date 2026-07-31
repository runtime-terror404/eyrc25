// =============================================================================
// Team ID    : 2401
// Theme      : MazeSolver Bot (MB)
// Authors    : Dibyendu Maity (not.dibyendu@gmail.com) and teams
// Filename   : pwm_generator.v
// License    : MIT License (See LICENSE file in project root)
// =============================================================================
//
// Module Name : pwm_generator
//
// Description : PWM signal generator with integrated clock divider.
//               Divides 3.125MHz → 195KHz (÷16) and generates a PWM output
//               with 4-bit duty cycle control (0-15 steps).
//
// Dependencies: None
// Target EDA  : Iverilog, GTKWave, Intel Quartus Prime, ModelSim
// Target HW   : Simulation / FPGA (Cyclone IV EP4CE22F17C6)
//
// Inputs      :
//   - clk_3125KHz   : 3.125 MHz clock input
//   - duty_cycle[3:0] : 4-bit duty cycle (0 = 0%, 15 = 100%)
//
// Outputs     :
//   - clk_195KHz    : 195 KHz divided clock output
//   - pwm_signal    : PWM output signal
// =============================================================================

module pwm_generator(
    input clk_3125KHz,
    input [3:0] duty_cycle,
    output reg clk_195KHz, pwm_signal
);
// clk_3125KHz: Input, clock signal used as the base for timing and counting
// duty_cycle: Input, 4-bit value (0-15) determining the on-time of the PWM signal
// clk_195KHz: Output, a slower clock signal, divided down from the input clock
// pwm_signal: Output, the final PWM signal

	initial begin
    clk_195KHz = 0; pwm_signal = 1;
	end
//////////////////DO NOT MAKE ANY CHANGES ABOVE THIS LINE //////////////////
    // clk_cnt: 3-bit counter used for dividing the input clock to generate clk_195KHz
    reg [2:0] clk_cnt = 0;

    // pwm_cnt: 4-bit counter used for generating the PWM waveform period
    reg [3:0] pwm_cnt = 0;   

    
    always @(posedge clk_3125KHz) begin
        /*
        Purpose:
        ---
        This block functions as a clock divider. It toggles the clk_195KHz signal
        every 8 cycles of the input clk_3125KHz, effectively dividing the 
        frequency by 16 (3.125MHz / 16 = ~195KHz).
        */
        if (!clk_cnt) 
            clk_195KHz <= ~clk_195KHz; 
        clk_cnt <= clk_cnt + 1'b1; 
    end

    
    always @(posedge clk_3125KHz) begin
        /*
        Purpose:
        ---
        This block generates the PWM signal. A 4-bit counter (pwm_cnt) creates a 
        period of 16 clock cycles. The pwm_signal is held high as long as 
        the counter's value is less than the specified duty_cycle, and low 
        otherwise, thus controlling the width of the pulse.
        */
        if (pwm_cnt == 4'd15)
            pwm_cnt <= 0;
        else
            pwm_cnt <= pwm_cnt + 1;

        pwm_signal <= (pwm_cnt < duty_cycle) ? 1'b1 : 1'b0;
    end

/*
Add your logic here
*/

//////////////////DO NOT MAKE ANY CHANGES BELOW THIS LINE //////////////////

endmodule
