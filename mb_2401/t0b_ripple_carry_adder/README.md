# t0b_ripple_carry_adder — 2-Bit Ripple Carry Adder

A 2-bit ripple carry adder built by cascading two 1-bit full adders. Demonstrates hierarchical design — a smaller module (`full_adder`) instantiated multiple times to build a larger circuit.

## Directory Structure

```
t0b_ripple_carry_adder/
├── Makefile                       # Build automation for Iverilog simulation
├── ripple_carry_adder.qpf         # Quartus Prime project file
├── ripple_carry_adder.qsf         # Quartus settings file (pin assignments, device)
├── rtl/
│   ├── full_adder.v               # 1-bit full adder
│   └── ripple_carry_adder.v       # 2-bit ripple carry adder (top)
└── tb/
    └── tb_ripple_carry_adder.v    # Testbench (e-Yantra provided)
```

## Architecture

```
   a[0] ──┬── full_adder (FA0) ── sum[0]
   b[0] ──┤     c_in → cin
          │     c_out → c1 (internal carry)
   a[1] ──┼── full_adder (FA1) ── sum[1]
   b[1] ──┤     c_in ← c1
          │     c_out → c_out
```

## About

| | |
|---|---|
| **Modules** | `ripple_carry_adder` (top), `full_adder` |
| **Inputs** | `a[1:0]`, `b[1:0]`, `cin` |
| **Outputs** | `sum[1:0]`, `c_out` |
| **Target FPGA** | Cyclone IV EP4CE22F17C6 |
| **Tested on** | Intel Quartus Prime 20.1 Lite Edition |

## Quick Simulation (Iverilog + GTKWave)

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
2. **File → Open Project** → select `ripple_carry_adder.qpf`
3. **Processing → Start Compilation** to synthesize
4. Use **Tools → Run Simulation Tool** for RTL simulation with ModelSim
