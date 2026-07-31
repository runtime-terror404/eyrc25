# t0d_riscv_compiler_test — RISC-V Compiler Toolchain Test

A simple LED blinker C program compiled for the RISC-V RV32IM architecture. This project verifies that the RISC-V GCC cross-compilation toolchain is correctly installed and can generate valid Verilog hex output for loading into the instruction memory of the `t1c_riscv_cpu`.

## Directory Structure

```
t0d_riscv_compiler_test/
├── README.md
└── rtl/
    ├── blink-compiler-test.c   # C test program (LED blinker)
    ├── generatehex.sh          # Build script: C → RISC-V ELF → hex
    ├── listing.lss             # Generated: disassembly listing
    └── output.hex              # Generated: Verilog hex for instruction memory
```

## About

| | |
|---|---|
| **Source** | `blink-compiler-test.c` |
| **Build Script** | `generatehex.sh` |
| **Target Architecture** | RV32IM (32-bit RISC-V with Integer + Multiply) |
| **Output** | `output.hex` (Verilog hex format, 4-byte reversed) |
| **Listing** | `listing.lss` (annotated disassembly) |

## Quick Build

```bash
cd rtl/

# Compile the default test program (blink-compiler-test.c)
./generatehex.sh

# Or compile a different C file
./generatehex.sh my_program.c
```

**Prerequisites:**
- RISC-V GCC cross-compiler (`riscv64-unknown-elf-gcc`)
- RISC-V binutils (`riscv64-unknown-elf-objdump`, `objcopy`)

The generated `output.hex` can be loaded into the `t1c_riscv_cpu` instruction memory.
