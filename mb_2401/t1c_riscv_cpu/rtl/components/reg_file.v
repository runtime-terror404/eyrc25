
// =============================================================================
// Team ID    : 2401
// Theme      : MazeSolver Bot (MB)
// Authors    : Dibyendu Maity (not.dibyendu@gmail.com) and teams
// Filename   : reg_file.v
// License    : MIT License (See LICENSE file in project root)
// =============================================================================
//
// Module Name : reg_file
//
// Description : 32×32-bit register file for RISC-V RV32I.
//               Two combinational read ports (rs1, rs2) and one synchronous
//               write port (rd). Register x0 is hardwired to zero.
//
// Dependencies: None
// Target EDA  : Iverilog, GTKWave, Intel Quartus Prime, ModelSim
// Target HW   : Simulation / FPGA (Cyclone IV EP4CE22F17C6)
// =============================================================================

module reg_file #(parameter DATA_WIDTH = 32 // DATA_WIDTH: Sets the bit-width of each register
) (
    input       clk,
    input       wr_en,
    input       [4:0] rd_addr1, rd_addr2, wr_addr,
    input       [DATA_WIDTH-1:0] wr_data,
    output      [DATA_WIDTH-1:0] rd_data1, rd_data2
);

// clk: Clock signal for synchronous write operations
// wr_en: Write enable signal, a high enables writing to the register file on the next posedge clk
// rd_addr1: 5-bit address for the first read port (rs1)
// rd_addr2: 5-bit address for the second read port (rs2)
// wr_addr: 5-bit address for the write port (rd)
// wr_data: Data to be written into the register file
// rd_data1: Data output from the first read port
// rd_data2: Data output from the second read port

// reg_file_arr: The internal storage array for the 32 registers

reg [DATA_WIDTH-1:0] reg_file_arr [0:31];

integer i;
initial begin
    /*
    Purpose:
    ---
    To initialize all 32 registers to zero at the beginning of a simulation,
    mimicking a hardware reset state.
    */
    for (i = 0; i < 32; i = i + 1) begin
        reg_file_arr[i] = 0;
    end
end

// register file write logic (synchronous)
always @(posedge clk) begin
    /*
    Purpose:
    ---
    Synchronously writes wr_data to the register specified by wr_addr on the
    positive edge of the clock, only if the write enable (wr_en) signal is high.
    This prevents race conditions and ensures predictable state changes.
    */
    if (wr_en) reg_file_arr[wr_addr] <= wr_data;
end

// register file read logic (combinational)
// This implements asynchronous reads and hardwires register 0 to zero.
assign rd_data1 = ( rd_addr1 != 0 ) ? reg_file_arr[rd_addr1] : 0;
assign rd_data2 = ( rd_addr2 != 0 ) ? reg_file_arr[rd_addr2] : 0;

endmodule

