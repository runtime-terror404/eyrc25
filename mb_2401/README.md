# Single-Cycle RV32I Processor
This repository contains the Verilog source code for a single-cycle processor implementing the RISC-V 32-bit (RV32I) base integer instruction set. This project was developed for the **MazeSolver Bot (MB)** theme.

**Team ID:** 2401

## Description

This is a simple single-cycle implementation of a 32-bit RISC-V processor. It follows a classic Harvard architecture, utilizing separate memories for instructions and data. The control unit generates all control signals combinatorially based on the instruction's opcode.

## Features

* **RV32I Base Integer Instruction Set:** Implements a core set of RV32I instructions, including:
    * **R-type:** `add`, `sub`, `sll`, `slt`, `sltu`, `xor`, `srl`, `sra`, `or`, `and`
    * **I-type:** `addi`, `slti`, `sltiu`, `xori`, `ori`, `andi`, `slli`, `srli`, `srai`, `lb`, `lh`, `lw`, `lbu`, `lhu`, `jalr`
    * **S-type:** `sb`, `sh`, `sw`
    * **B-type:** `beq`, `bne`, `blt`, `bge`, `bltu`, `bgeu`
    * **U-type:** `lui`, `auipc`
    * **J-type:** `jal`
* **Single-Cycle Datapath:** All instructions execute in a single clock cycle.
* **Harvard Architecture:** Uses separate `instr_mem` and `data_mem` modules.
* **Modular Design:** The processor is broken down into a `controller` and `datapath`, which are further composed of smaller, reusable modules.

## File Structure

The project is organized into the following Verilog modules:

| Filename | Description |
| :--- | :--- |
| `t1c_riscv_cpu.v` | **Top-level module:** Connects the CPU core, instruction memory, and data memory. Includes logic for external memory loading during reset. |
| `riscv_cpu.v` | **CPU Core:** Instantiates and connects the `controller` and `datapath`. |
| `datapath.v` | **Main Datapath:** Contains the PC, register file, ALU, immediate generator, multiplexers, and all major datapth connections. |
| `controller.v` | **Main Controller:** Instantiates the decoders and branch logic to generate all control signals for the datapath. |
| `main_decoder.v` | Decodes the 7-bit opcode to generate primary control signals (e.g., `RegWrite`, `ALUSrc`, `ALUOp`, `MemWrite`). |
| `alu_decoder.v` | Decodes instruction fields (`ALUOp`, `funct3`, `funct7b5`) to generate the final 4-bit `ALUControl` signal. |
| `branch_logic.v` | Implements the logic for all six RV32I branch conditions (BEQ, BNE, BLT, BGE, BLTU, BGEU). |
| `alu.v` | The 32-bit Arithmetic Logic Unit (ALU). Performs all arithmetic, logical, shift, and comparison operations. |
| `reg_file.v` | The 32x32-bit register file with two combinational read ports, one synchronous write port, and `x0` hardwired to zero. |
| `imm_extend.v` | The immediate generation unit. Correctly sign-extends and formats immediates for I, S, B, J, and U-type instructions. |
| `instr_mem.v` | The instruction memory (ROM). It is initialized from an external hex file (`rv32i_test.hex`). |
| `data_mem.v` | The data memory (RAM). It has a synchronous write and a combinational read port. |
| `adder.v` | A simple parameterized 32-bit adder. Used for PC + 4 and branch target calculation. |
| `reset_ff.v` | A parameterized N-bit D flip-flop with a synchronous reset. Used for the Program Counter. |
| `mux2.v` | A parameterized 2-to-1 multiplexer. |
| `mux3.v` | A parameterized 3-to-1 multiplexer. |
| `mux4.v` | A parameterized 4-to-1 multiplexer. |

## Simulation

To simulate this processor, you will need:

1.  A Verilog simulator (e.g., ModelSim, Vivado, Icarus Verilog).
2.  A testbench file (not included here) that instantiates the `t1c_riscv_cpu` module and provides `clk` and `reset` signals.
3.  An instruction file named **`rv32i_test.hex`** in your simulation directory. This file should contain your RISC-V machine code in hexadecimal format, one instruction per line. The `instr_mem.v` module will load this file at the start of the simulation.

## Authors

* Dibyendu Maity
* Ankit Dwibedi
* Sankalpa Basak
* Snehajit Paul
