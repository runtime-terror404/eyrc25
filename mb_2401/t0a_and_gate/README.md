# t0a_and_gate — 2-Input AND Gate

A basic 2-input combinational AND gate implemented in Verilog HDL. This is the foundational project introducing FPGA design flow with Intel Quartus Prime and RTL simulation with Iverilog/GTKWave.

## Directory Structure

```
t0a_and_gate/
├── Makefile              # Build automation for Iverilog simulation
├── AND_GATE.qpf          # Quartus Prime project file
├── AND_GATE.qsf          # Quartus settings file (pin assignments, device)
├── AND_GATE.qws          # Quartus workspace (auto-generated)
├── Waveform.vwf          # Quartus waveform configuration
├── rtl/
│   └── and_gate.v        # 2-input AND gate RTL
└── tb/
    └── and_gate_test_bench.v  # Testbench (e-Yantra provided)
```

## About

| | |
|---|---|
| **Module** | `and_gate` |
| **Inputs** | `a`, `b` |
| **Outputs** | `out` |
| **Logic** | `out = a & b` |
| **Target FPGA** | Cyclone IV EP4CE22F17C6 |
| **Tested on** | Intel Quartus Prime 20.1 Lite Edition |

## Quick Simulation (Iverilog + GTKWave)

If you don't have an FPGA board, you can still run the simulation:

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
2. **File → Open Project** → select `AND_GATE.qpf`
3. The project will load with all pin assignments and device settings from `AND_GATE.qsf`
4. **Processing → Start Compilation** to synthesize
5. Use **Tools → Run Simulation Tool** for RTL simulation with ModelSim
