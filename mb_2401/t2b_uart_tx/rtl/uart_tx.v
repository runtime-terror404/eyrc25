// =============================================================================
// Team ID    : 2401
// Theme      : MazeSolver Bot (MB)
// Authors    : Dibyendu Maity (not.dibyendu@gmail.com) and teams
// Filename   : uart_tx.v
// License    : MIT License (See LICENSE file in project root)
// =============================================================================
//
// Module Name : uart_tx
//
// Description : UART Transmitter with configurable parity.
//               Serializes 8-bit parallel data, adds start bit (0), parity
//               bit (even/odd), and stop bit (1). Timed for 115200 baud
//               from a 3.125MHz clock (27 clocks/bit).
//
// Dependencies: None
// Target EDA  : Iverilog, GTKWave, Intel Quartus Prime, ModelSim
// Target HW   : Simulation / FPGA (Cyclone IV EP4CE22F17C6)
//
// Inputs      :
//   - clk_3125    : 3.125 MHz clock
//   - parity_type : 0 = even parity, 1 = odd parity
//   - tx_start    : Start transmission (1-cycle pulse)
//   - data[7:0]   : 8-bit parallel data to transmit
//
// Outputs     :
//   - tx      : UART serial output line
//   - tx_done : Transmission complete flag (1-cycle pulse)
// =============================================================================

/*
Module UART Transmitter

This module implements a UART transmitter. It serializes an 8-bit parallel data byte,
adds a start bit, a parity bit, and a stop bit for asynchronous serial transmission.

Input:  clk_3125    - 3125 KHz clock (Note: Baud rate timing is derived from this)
        parity_type - even(0)/odd(1) parity type
        tx_start    - signal to start the communication
        data        - 8-bit data line to transmit

Output: tx          - UART Transmission Line
        tx_done     - message transmitted flag

Baudrate : 115200 bps
*/

// module declaration
module uart_tx (
    input clk_3125,
    input parity_type,
    tx_start,
    input [7:0] data,
    output reg tx,
    tx_done
);

  initial begin
    tx = 1'b1;
    tx_done = 1'b0;
  end
  //////////////////DO NOT MAKE ANY CHANGES ABOVE THIS LINE//////////////////

  /* Add your logic here */

  localparam ST_IDLE = 1'b0;
  localparam ST_SEND = 1'b1;

  reg state = ST_IDLE;
  reg [3:0] bit_index = 4'd0;
  reg [4:0] bit_timer = 5'd0;

  // Compute parity directly from input data
  wire spar_calc = ^data ^ parity_type;

  always @(posedge clk_3125) begin
    case (state)
      ST_IDLE: begin
        tx_done <= 1'b0;
        tx <= 1'b1;

        if (tx_start) begin
          bit_index <= 4'd0;
          bit_timer <= 5'd0;
          tx <= 1'b0;  // Start bit
          state <= ST_SEND;
        end
      end

      ST_SEND: begin
        tx_done <= 1'b0;

        if (bit_timer < 5'd26) begin
          bit_timer <= bit_timer + 5'd1;

          // Set tx_done when we're on the last cycle of the stop bit
          if (bit_index == 4'd10 && bit_timer == 5'd25) begin
            tx_done <= 1'b1;
          end
        end else begin
          bit_timer <= 5'd0;

          if (bit_index < 4'd10) begin
            bit_index <= bit_index + 4'd1;

            // Output bits directly from input data with proper indexing
            if (bit_index < 4'd8) begin
              tx <= data[7-bit_index];  // MSB first (standard UART)
            end else if (bit_index == 4'd8) begin
              tx <= spar_calc;  // Parity bit
            end else begin
              tx <= 1'b1;  // Stop bit
            end
          end else begin
            // Transmission complete
            state <= ST_IDLE;
            tx <= 1'b1;
          end
        end
      end

      default: begin
        state <= ST_IDLE;
        tx <= 1'b1;
        tx_done <= 1'b0;
      end
    endcase
  end


  //////////////////DO NOT MAKE ANY CHANGES BELOW THIS LINE//////////////////

endmodule

