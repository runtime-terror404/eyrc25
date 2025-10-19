/*
Module HC_SR04 Ultrasonic Sensor

This module will detect objects present in front of the range, and give the distance in mm.

Input:  clk_50M - 50 MHz clock
        reset   - reset input signal (Use negative reset)
        echo_rx - receive echo from the sensor

Output: trig    - trigger sensor for the sensor
        op     -  output signal to indicate object is present.
        distance_out - distance in mm, if object is present.
*/

// module Declaration
module t1b_ultrasonic(
    input clk_50M, reset, echo_rx,
    output reg trig,
    output op,
    output wire [15:0] distance_out
);

initial begin
    trig = 0;
end
//////////////////DO NOT MAKE ANY CHANGES ABOVE THIS LINE //////////////////

//////////////////DO NOT MAKE ANY CHANGES ABOVE THIS LINE //////////////////

/*
Add your logic here
*/

// FSM State Definitions
localparam S_INIT_DELAY   = 2'd0;
localparam S_TRIG_PULSE   = 2'd1;
localparam S_MEASURE_ECHO = 2'd2;
localparam S_CYCLE_DELAY  = 2'd3;

// Timing Parameters (for 50MHz clock with 20ns period)
localparam COUNT_1US   = 6'd50;        // 1us / 20ns = 50 clock cycles
localparam COUNT_10US  = 10'd500;      // 10us / 20ns = 500 clock cycles
localparam COUNT_12MS_BASE = 24'd600000;   // 12ms / 20ns = 600000 clock cycles

localparam STATE_TRANSITION_OVERHEAD = 3'd4;
localparam COUNT_12MS = COUNT_12MS_BASE + COUNT_10US + STATE_TRANSITION_OVERHEAD;

localparam OBSTACLE_THRESHOLD = 16'd70; // 70mm

// FSM state register
reg [1:0] state;
reg [23:0] total_cycle_counter; // Single unified counter
reg [16:0] echo_counter;        // Reduced to 17 bits (enough for max distance)
reg [15:0] distance_reg;
reg echo_prev;
reg echo_measuring;

// Edge detection
wire echo_rising_edge = echo_rx && !echo_prev;
wire echo_falling_edge = !echo_rx && echo_prev;

// Initialize outputs
initial begin
    distance_reg = 16'b0;
end

// FSM, counter, and output logic
always @(posedge clk_50M or negedge reset) begin
    if (!reset) begin
        state <= S_INIT_DELAY;
        total_cycle_counter <= 0;
        echo_counter <= 0;
        trig <= 1'b0;
        distance_reg <= 0;
        echo_prev <= 0;
        echo_measuring <= 0;
    end else begin
        echo_prev <= echo_rx;
        
        // Unified counter always increments
        total_cycle_counter <= total_cycle_counter + 1;
        
        case (state)
            S_INIT_DELAY: begin
                trig <= 1'b0;
                echo_measuring <= 0;
                
                // Wait for 1µs to let the sensor settle
                if (total_cycle_counter >= COUNT_1US - 1) begin
                    state <= S_TRIG_PULSE;
                    total_cycle_counter <= 0;
                end
            end

            S_TRIG_PULSE: begin
                // Set trig pin HIGH for 10µs
                trig <= 1'b1;
                echo_measuring <= 0;
                
                if (total_cycle_counter >= COUNT_10US - 1) begin
                    // After 10µs, move to Measure Echo
                    state <= S_MEASURE_ECHO;
                    echo_counter <= 0;
                end
            end

            S_MEASURE_ECHO: begin
                trig <= 1'b0;
                
                // Start timer when echo goes HIGH
                if (echo_rising_edge) begin
                    echo_measuring <= 1;
                    echo_counter <= 0;
                end
                
                // Count while echo is HIGH
                if (echo_measuring && echo_rx) begin
                    echo_counter <= echo_counter + 1;
                end
                
                // Stop timer when echo goes LOW
                if (echo_falling_edge && echo_measuring) begin
                    echo_measuring <= 0;
                    // Calculate distance in mm using exact formula but let synthesizer optimize
                    // Distance = (echo_counter * 20ns * 340m/s) / 2
                    // Distance = (echo_counter * 20e-9 * 340000) / 2
                    // Distance = echo_counter * 0.0034 mm
                    // Distance = (echo_counter * 34) / 10000
                    // Factor: (echo_counter * 17) / 5000 is mathematically equivalent
                    distance_reg <= (echo_counter * 17) / 5000;
                    state <= S_CYCLE_DELAY;
                end
                
                // Timeout protection - move to cycle delay if no echo
                if (total_cycle_counter >= COUNT_12MS - COUNT_1US - 1) begin
                    if (!echo_measuring || echo_counter == 0) begin
                        distance_reg <= 0;
                    end
                    state <= S_CYCLE_DELAY;
                end
            end

            S_CYCLE_DELAY: begin
                trig <= 1'b0;
                echo_measuring <= 0;
                
                // Wait until total 12ms has passed since start of trigger pulse
                if (total_cycle_counter >= COUNT_12MS - 1) begin
                    state <= S_INIT_DELAY;
                    total_cycle_counter <= 0;
                end
            end

            default: begin
                state <= S_INIT_DELAY;
                total_cycle_counter <= 0;
                distance_reg <= 0;
            end
        endcase
    end
end

// Assign outputs
assign distance_out = distance_reg;
assign op = (distance_reg > 0) && (distance_reg < OBSTACLE_THRESHOLD);

//////////////////DO NOT MAKE ANY CHANGES BELOW THIS LINE //////////////////

//////////////////DO NOT MAKE ANY CHANGES BELOW THIS LINE //////////////////

endmodule
