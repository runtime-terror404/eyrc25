/*
# Team ID:          2401
# Theme:            MazeSolver Bot (MB)
# Author List:      Dibyendu Maity, Ankit Dwibedi, Sankalpa Basak, Snehajit Paul
# Filename:         uart_tx.v
# File Description: This module implements a UART (Universal Asynchronous Receiver-Transmitter) transmitter. It serializes an 8-bit parallel data byte, adds a start bit, a calculated parity bit, and a stop bit.
# Global variables: None
*/

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
module uart_tx(
    input clk_3125,
    input parity_type,tx_start,
    input [7:0] data,
    output reg tx, tx_done
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
                        tx <= data[7 - bit_index];  // MSB first (standard UART)
                    end else if (bit_index == 4'd8) begin
                        tx <= spar_calc;            // Parity bit
                    end else begin
                        tx <= 1'b1;                 // Stop bit
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

