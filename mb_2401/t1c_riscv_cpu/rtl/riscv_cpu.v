// =============================================================================
// Team ID    : 2401
// Theme      : MazeSolver Bot (MB)
// Authors    : Dibyendu Maity (not.dibyendu@gmail.com) and teams
// Filename   : riscv_cpu.v
// License    : MIT License (See LICENSE file in project root)
// =============================================================================
//
// Module Name : riscv_cpu
//
// Description : Single-cycle RISC-V RV32I CPU core.
//               Instantiates the controller and datapath, connecting them
//               with internal control wires. Intended to be used with
//               external instruction and data memories.
//
// Dependencies: controller.v, datapath.v
// Target EDA  : Iverilog, GTKWave, Intel Quartus Prime, ModelSim
// Target HW   : Simulation / FPGA (Cyclone IV EP4CE22F17C6)
// =============================================================================

module riscv_cpu (
    input         clk, reset,
    output [31:0] PC,
    input  [31:0] Instr,
    output        MemWrite,
    output [31:0] Mem_WrAddr, Mem_WrData,
    input  [31:0] ReadData,
    output [31:0] Result
);

// clk: Input, the system clock signal
// reset: Input, the active-high system reset signal
// PC: Output, the current 32-bit Program Counter value
// Instr: Input, the 32-bit instruction fetched from instruction memory
// MemWrite: Output, control signal to enable writing to data memory
// Mem_WrAddr: Output, 32-bit address for data memory access
// Mem_WrData: Output, 32-bit data to be written to data memory
// ReadData: Input, 32-bit data read from data memory
// Result: Output, 32-bit data to be written back to the register file (also used by JALR)


// --- Internal Control Wires ---
// These wires connect the controller module to the datapath module.
wire        ALUSrc, RegWrite, Jump, Zero, PCSrc, ALUResult0;  // Added ALUResult0
wire [1:0]  ResultSrc, ImmSrc;
wire [3:0]  ALUControl;  

// ALUSrc: Control signal, selects ALU's second operand (register or immediate)
// RegWrite: Control signal, enables writing to the register file
// Jump: Control signal, indicates a JAL or JALR instruction
// Zero: ALU flag, 1 if the ALU result is zero (from datapath to controller)
// PCSrc: Control signal, selects the next PC address (PC+4 or branch/jump target)
// ALUResult0: LSB of ALU result (from datapath to controller, for branch logic)
// ResultSrc: Control signal, selects the data for register write-back
// ImmSrc: Control signal, selects the immediate generation format
// ALUControl: 4-bit control signal selecting the ALU's operation

// Instantiate the Controller
controller  c   (Instr[6:0], Instr[14:12], Instr[30], Zero, ALUResult0,
                ResultSrc, MemWrite, PCSrc, ALUSrc, RegWrite, Jump,
                ImmSrc, ALUControl);

// Instantiate the Datapath
datapath    dp  (clk, reset, ResultSrc, PCSrc,
                ALUSrc, RegWrite, ImmSrc, ALUControl,
                Zero, PC, Instr, Mem_WrAddr, Mem_WrData, ReadData, Result, ALUResult0);

endmodule
