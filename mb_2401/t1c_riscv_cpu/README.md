# t1c_riscv_cpu — Single-Cycle RISC-V RV32I CPU

A complete single-cycle RISC-V CPU implementing the RV32I base integer instruction set. Designed in Verilog HDL with a modular architecture separating the controller and datapath. This CPU served as the brain of the MazeSolver Bot.

## Directory Structure

```
t1c_riscv_cpu/
├── Makefile                     # Build automation for Iverilog simulation
├── t1c_riscv_cpu.qpf            # Quartus Prime project file
├── t1c_riscv_cpu.qsf            # Quartus settings file (pin assignments, device)
├── rtl/
│   ├── t1c_riscv_cpu.v          # Top-level system (CPU + memories)
│   ├── riscv_cpu.v              # CPU core (controller + datapath)
│   ├── data_mem.v               # Data memory (64 words × 32-bit RAM)
│   ├── instr_mem.v              # Instruction memory (512 words × 32-bit ROM)
│   ├── rv32i_test.s             # RV32I assembly test program
│   ├── rv32i_test.hex           # Pre-compiled test hex
│   ├── rv32i_book.hex           # Book example hex
│   └── components/
│       ├── adder.v              # N-bit adder (PC+4, branch target)
│       ├── alu.v                # Arithmetic Logic Unit (10 operations)
│       ├── alu_decoder.v        # ALU control decoder
│       ├── branch_logic.v       # Branch condition evaluator
│       ├── controller.v         # Top-level controller
│       ├── datapath.v           # Main datapath
│       ├── imm_extend.v         # Immediate extension unit (I/S/B/J/U)
│       ├── main_decoder.v       # Opcode decoder
│       ├── mux2.v               # 2:1 multiplexer
│       ├── mux3.v               # 3:1 multiplexer
│       ├── mux4.v               # 4:1 multiplexer
│       ├── reg_file.v           # 32×32-bit register file
│       └── reset_ff.v           # D flip-flop with reset
└── tb/
    └── tb.v                     # Testbench (e-Yantra provided)
```

## Architecture

```
                    ┌─────────────┐
                    │  controller │
                    │ ┌─────────┐ │
   Instr[6:0] ─────►│ │main_dec │─┼──► RegWrite, ALUSrc, MemWrite...
   Instr[14:12] ───►│ │alu_dec  │─┼──► ALUControl[3:0]
   Instr[30] ──────►│ │branch   │─┼──► PCSrc
                    │ └─────────┘ │
                    └──────┬──────┘
                           │
                    ┌──────▼──────┐
                    │   datapath  │
   clk ────────────►│ ┌─────────┐ │
   reset ──────────►│ │PC+4/PC  │─┼──► PC[31:0]
                    │ │Reg File │─┼──► Mem_WrAddr, Mem_WrData
                    │ │Imm Ext  │ │
                    │ │ALU      │─┼──► Result[31:0]
                    │ │Muxes    │ │
                    │ └─────────┘ │
                    └─────────────┘
```

## Supported Instructions (RV32I)

| Type | Instructions |
|------|-------------|
| **R-type** | ADD, SUB, SLL, SLT, SLTU, XOR, SRL, SRA, OR, AND |
| **I-type ALU** | ADDI, SLLI, SLTI, SLTIU, XORI, SRLI, SRAI, ORI, ANDI |
| **I-type Load** | LB, LH, LW, LBU, LHU |
| **I-type Jump** | JALR |
| **S-type** | SB, SH, SW |
| **B-type** | BEQ, BNE, BLT, BGE, BLTU, BGEU |
| **U-type** | LUI, AUIPC |
| **J-type** | JAL |

## About

| | |
|---|---|
| **Top Module** | `t1c_riscv_cpu` |
| **Architecture** | Single-cycle, Harvard |
| **ISA** | RV32I (32-bit RISC-V Integer) |
| **Registers** | 32 × 32-bit (x0 hardwired to 0) |
| **Total Modules** | 17 Verilog files (~13 components + 4 top-level) |
| **Target FPGA** | Cyclone IV EP4CE22F17C6 |
| **Tested on** | Intel Quartus Prime 20.1 Lite Edition |

## Quick Simulation (Iverilog + GTKWave)

> **⚠️ Known Simulator Difference:** Iverilog may report timing mismatches
> due to delta-cycle resolution differences between Iverilog and ModelSim.
> This design was **verified and passed all testbench checks** on Intel Quartus
> Prime 20.1 / ModelSim — the authoritative simulation environment used by e-Yantra.

```bash
# Compile and run simulation
make

# View waveforms in GTKWave
make wave

# Clean generated files
make clean
```

**Prerequisites:**
- [Iverilog](https://github.com/steveicarus/iverilog) (`sudo apt install iverilog`)
- [GTKWave](https://github.com/gtkwave/gtkwave) (`sudo apt install gtkwave`)

## Opening in Quartus Prime

1. Launch **Intel Quartus Prime 20.1 Lite Edition** (recommended — tested on this version)
2. **File → Open Project** → select `t1c_riscv_cpu.qpf`
3. `t1c_riscv_cpu.v` is the top-level entity
4. **Processing → Start Compilation** to synthesize
5. Use **Tools → Run Simulation Tool** for RTL simulation with ModelSim

## Recompiling the Test Program

```bash
cd rtl/
# Assemble the test program
riscv64-unknown-elf-as -march=rv32i -mabi=ilp32 rv32i_test.s -o rv32i_test.o
riscv64-unknown-elf-ld -Ttext=0x0 rv32i_test.o -o rv32i_test.elf
riscv64-unknown-elf-objcopy -O verilog rv32i_test.elf rv32i_test.hex
```
