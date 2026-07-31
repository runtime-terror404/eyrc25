// =============================================================================
// Team ID    : 2401
// Theme      : MazeSolver Bot (MB)
// Authors    : Dibyendu Maity (not.dibyendu@gmail.com) and teams
// Filename   : t1c_riscv_cpu.v
// License    : MIT License (See LICENSE file in project root)
// =============================================================================
//
// Module Name : t1c_riscv_cpu
//
// Description : Complete single-cycle RISC-V RV32I system.
//               Instantiates the CPU core (riscv_cpu), instruction memory
//               (instr_mem), and data memory (data_mem). Supports external
//               data memory writes during reset for pre-loading data.
//               This is the top-level module for Quartus synthesis.
//
// Dependencies: riscv_cpu.v, instr_mem.v, data_mem.v
// Target EDA  : Iverilog, GTKWave, Intel Quartus Prime, ModelSim
// Target HW   : Simulation / FPGA (Cyclone IV EP4CE22F17C6)
// =============================================================================

module t1c_riscv_cpu (
    input         clk, reset,
    input         Ext_MemWrite,
    input  [31:0] Ext_WriteData, Ext_DataAdr,
    output        MemWrite,
    output [31:0] WriteData, DataAdr, ReadData,
    output [31:0] PC, Result
);

// clk: Input, the global system clock
// reset: Input, the global active-high reset
// Ext_MemWrite: Input, external write enable, used to write to data memory during reset
// Ext_WriteData: Input, external 32-bit data to be written during reset
// Ext_DataAdr: Input, external 32-bit address for writing during reset
// MemWrite: Output, the final write enable signal passed to the data memory
// WriteData: Output, the final 32-bit write data passed to the data memory
// DataAdr: Output, the final 32-bit address passed to the data memory
// ReadData: Output, 32-bit data read from data memory (passed from datamem to rvcpu)
// PC: Output, the 32-bit Program Counter from the CPU core
// Result: Output, the 32-bit result from the CPU's write-back stage

// --- Internal Wires ---
wire [31:0] Instr;
wire [31:0] DataAdr_rv32, WriteData_rv32;
wire        MemWrite_rv32;

// Instr: Internal wire, carries the 32-bit instruction from instr_mem to the rvcpu
// DataAdr_rv32: Internal wire, carries the 32-bit data address from the rvcpu
// WriteData_rv32: Internal wire, carries the 32-bit write data from the rvcpu
// MemWrite_rv32: Internal wire, carries the write enable signal from the rvcpu

// instantiate processor and memories
riscv_cpu rvcpu (
    .clk(clk),
    .reset(reset),
    .PC(PC),
    .Instr(Instr),
    .MemWrite(MemWrite_rv32),
    .Mem_WrAddr(DataAdr_rv32),
    .Mem_WrData(WriteData_rv32),
    .ReadData(ReadData),
    .Result(Result)
);

instr_mem instrmem (
    .instr_addr(PC),
    .instr(Instr)
);

data_mem datamem (
    .clk(clk),
    .wr_en(MemWrite),
    .wr_addr(DataAdr),
    .wr_data(WriteData),
    .rd_data_mem(ReadData)
);

// This logic allows an external host to write to the data memory
// while the CPU is held in reset.
// When reset=1, the external signals are used.
// When reset=0, the CPU's signals are used.
assign MemWrite  = (Ext_MemWrite && reset) ? 1'b1 : MemWrite_rv32;
assign WriteData = (Ext_MemWrite && reset) ? Ext_WriteData : WriteData_rv32;
assign DataAdr   = reset ? Ext_DataAdr : DataAdr_rv32;

endmodule
