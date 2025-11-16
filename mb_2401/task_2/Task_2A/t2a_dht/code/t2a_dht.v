/*
# Team ID:          2401
# Theme:            MazeSolver Bot (MB)
# Author List:      Dibyendu Maity, Ankit Dwibedi, Sankalpa Basak, Snehajit Paul
# Filename:         t2a_dht.v
# File Description: This module implements a controller for DHT11 temperature and humidity sensor. It uses a Finite State Machine (FSM) to initiate communication, read the 40-bit data frame, and extract temperature and humidity values with checksum validation.
# Global variables: None
*/

/*
Module DHT11 Temperature and Humidity Sensor Controller

This module interfaces with DHT11 sensor to read temperature and relative humidity data.
The module acts as master, controlling the bidirectional data line and implementing the
complete DHT11 communication protocol including start signal, response wait, data reception,
and checksum validation.

Input:  clk_50M - 50 MHz clock
        reset   - reset input signal (active-low asynchronous reset)

Inout:  sensor  - bidirectional data line for DHT11 communication

Output: T_integral  - 8-bit integer part of temperature value
        T_decimal   - 8-bit decimal part of temperature value
        RH_integral - 8-bit integer part of relative humidity value
        RH_decimal  - 8-bit decimal part of relative humidity value
        Checksum    - 8-bit checksum received from DHT11
        data_valid  - high for one clock cycle when valid data is received
*/


module t2a_dht(
    input clk_50M,
    input reset,
    inout sensor,
    output reg [7:0] T_integral,
    output reg [7:0] RH_integral,
    output reg [7:0] T_decimal,
    output reg [7:0] RH_decimal,
    output reg [7:0] Checksum,
    output reg data_valid
);

    initial begin
        T_integral = 0;
        RH_integral = 0;
        T_decimal = 0;
        RH_decimal = 0;
        Checksum = 0;
        data_valid = 0;
    end
//////////////////DO NOT MAKE ANY CHANGES ABOVE THIS LINE //////////////////


// Timing Constants (for 50MHz clock with 20ns period)
localparam [19:0] CYCLES_18MS   = 20'd900000; // 18ms minimum idle time between measurements
localparam [11:0] CYCLES_40US   = 12'd2000;   // 40us request high pulse duration
localparam [12:0] THRESHOLD_0_1 = 13'd2400;   // 48us threshold to distinguish logic 0 from 1

// FSM State Definitions
localparam [3:0] S_IDLE      = 4'd0; // State: Hold line LOW (18ms idle between readings)
localparam [3:0] S_REQ_LOW   = 4'd1; // State: Pull line LOW for 18ms (start signal)
localparam [3:0] S_REQ_HIGH  = 4'd2; // State: Pull line HIGH for 40us then release
localparam [3:0] S_RELEASE   = 4'd3; // State: Wait for sensor response falling edge
localparam [3:0] S_RESP_LOW  = 4'd4; // State: Wait for sensor response rising edge (80us LOW)
localparam [3:0] S_RESP_HIGH = 4'd5; // State: Wait for data transmission start (80us HIGH)
localparam [3:0] S_BIT_LOW   = 4'd6; // State: Wait for bit HIGH pulse (50us LOW per bit)
localparam [3:0] S_BIT_HIGH  = 4'd7; // State: Measure HIGH pulse width to decode bit
localparam [3:0] S_FINISH    = 4'd8; // State: Process data and assert data_valid

reg [3:0] state; // FSM state register

// Bidirectional sensor line control
reg sensor_drive; // sensor_drive: 0 = module drives line, 1 = high-Z (sensor drives)
reg sensor_out;   // sensor_out: Output value when module is driving the line

assign sensor = sensor_drive ? 1'bz : sensor_out;

// Input synchronizer for edge detection and metastability prevention
reg [2:0] sync; // sync: 3-stage synchronizer for sensor input

always @(posedge clk_50M or negedge reset) begin
    if (!reset)
        sync <= 3'b111;
    else
        sync <= { sync[1:0], (sensor === 1'bz || sensor === 1'bx) ? 1'b1 : sensor };
end

wire s_val       = sync[2];            // s_val: Current synchronized sensor value
wire rise_e      = (sync[1:0] == 2'b01); // rise_e: Rising edge detection
wire fall_e      = (sync[1:0] == 2'b10); // fall_e: Falling edge detection
wire sensor_is_z = (sensor === 1'bz);    // sensor_is_z: Flag indicating sensor line is high-Z

// Internal Registers
reg [19:0] cnt;          // cnt: General purpose counter for timing (20 bits for 18ms)
reg [39:0] data_buf;     // data_buf: Buffer to store 40-bit data frame from DHT11
reg [5:0] bit_i;         // bit_i: Bit index counter (0-39) for data reception
reg [11:0] high_cnt;     // high_cnt: Counter for measuring HIGH pulse width (12 bits for 70us)
reg [2:0] finish_delay;  // finish_delay: Delay counter in FINISH state for timing alignment

// Checksum calculation
wire [7:0] calc_checksum = data_buf[39:32] + data_buf[31:24] + data_buf[23:16] + data_buf[15:8];

// Main FSM
always @(posedge clk_50M or negedge reset) begin
    /*
    Purpose:
    ---
    This block implements the main Finite State Machine for DHT11 communication.
    It controls the bidirectional sensor line, generates the start signal, waits
    for sensor response, reads 40 bits of data, validates checksum, and outputs
    temperature and humidity values. The FSM ensures proper timing for all phases
    of the DHT11 protocol.
    */
    if (!reset) begin
        state <= S_IDLE;
        sensor_drive <= 1'b1;
        sensor_out <= 1'b1;

        cnt <= 20'd0;
        data_buf <= 40'd0;
        bit_i <= 6'd0;
        high_cnt <= 12'd0;
        finish_delay <= 3'd0;

        RH_integral <= 8'd0;
        RH_decimal  <= 8'd0;
        T_integral  <= 8'd0;
        T_decimal   <= 8'd0;
        Checksum    <= 8'd0;
        data_valid  <= 1'b0;
    end else begin
        data_valid <= 1'b0;

        case(state)

        S_IDLE: begin
            cnt <= 20'd0;
            sensor_drive <= 1'b0;
            sensor_out   <= 1'b0;
            state <= S_REQ_LOW;
        end

        S_REQ_LOW: begin
            cnt <= cnt + 20'd1;
            if (cnt >= CYCLES_18MS - 20'd1) begin
                cnt <= 20'd0;
                sensor_out <= 1'b1;
                state <= S_REQ_HIGH;
            end
        end

        S_REQ_HIGH: begin
            cnt <= cnt + 20'd1;
            if (cnt >= CYCLES_40US - 20'd1) begin
                cnt <= 20'd0;
                sensor_drive <= 1'b1;
                state <= S_RELEASE;
            end
        end

        S_RELEASE: begin
            if (fall_e) begin
                state <= S_RESP_LOW;
            end
        end

        S_RESP_LOW: begin
            if (rise_e) begin
                state <= S_RESP_HIGH;
            end
        end

        S_RESP_HIGH: begin
            if (fall_e) begin
                bit_i <= 6'd0;
                data_buf <= 40'd0;
                state <= S_BIT_LOW;
            end
        end

        S_BIT_LOW: begin
            if (rise_e) begin
                high_cnt <= 12'd1;
                state <= S_BIT_HIGH;
            end
        end

        S_BIT_HIGH: begin
            if (s_val && !sensor_is_z)
                high_cnt <= high_cnt + 12'd1;

            if (fall_e || (sensor_is_z && sync[1]==1'b1)) begin

                if (high_cnt > THRESHOLD_0_1)
                    data_buf[39-bit_i] <= 1'b1;
                else
                    data_buf[39-bit_i] <= 1'b0;

                bit_i <= bit_i + 6'd1;
                high_cnt <= 12'd0;

                if (bit_i == 6'd39) begin
                    finish_delay <= 3'd0;
                    state <= S_FINISH;
                end else begin
                    state <= S_BIT_LOW;
                end
            end
        end

        S_FINISH: begin
            finish_delay <= finish_delay + 3'd1;
            
            if (finish_delay == 3'd2) begin
                if (calc_checksum == data_buf[7:0]) begin
                    RH_integral <= data_buf[39:32];
                    RH_decimal  <= data_buf[31:24];
                    T_integral  <= data_buf[23:16];
                    T_decimal   <= data_buf[15:8];
                    Checksum    <= data_buf[7:0];
                    data_valid <= 1;
                end

                sensor_drive <= 0;
                sensor_out   <= 0;

                state <= S_IDLE;
            end
        end

        default: state <= S_IDLE;

        endcase
    end
end


//////////////////DO NOT MAKE ANY CHANGES BELOW THIS LINE //////////////////
  
endmodule
