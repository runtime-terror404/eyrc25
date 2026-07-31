# t0c_sequence_detector — "1094" Sequence Detector FSM

A Moore-style Finite State Machine that detects the pattern **"1094"** from a stream of 4-bit BCD digits. The detector asserts `pattern` high for one clock cycle whenever the complete sequence is recognized.

## Directory Structure

```
t0c_sequence_detector/
├── Makefile                     # Build automation for Iverilog simulation
├── sequence_detector.qpf        # Quartus Prime project file
├── sequence_detector.qsf        # Quartus settings file (pin assignments, device)
├── rtl/
│   └── sequence_detector.v      # Sequence detector FSM (pattern "1094")
└── tb/
    └── tb_sequence_detector.v   # Testbench (e-Yantra provided)
```

## State Machine

```
                  1         0         9         4
    ST_ONE ──────────► ST_ZERO ──► ST_NINE ──► ST_FOUR ──► pattern=1
      ▲                    │          │           │
      └────────────────────┴──────────┴───────────┘  (on mismatch, back to ST_ONE)
```

| State | Meaning |
|-------|---------|
| `ST_ONE` | Waiting for '1' |
| `ST_ZERO` | Got '1', waiting for '0' |
| `ST_NINE` | Got '10', waiting for '9' |
| `ST_FOUR` | Got '109', waiting for '4' → assert pattern |

## About

| | |
|---|---|
| **Module** | `sequence_detector` |
| **Inputs** | `clock`, `number[3:0]` (BCD digit) |
| **Outputs** | `pattern` (high on sequence detected) |
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
2. **File → Open Project** → select `sequence_detector.qpf`
3. **Processing → Start Compilation** to synthesize
4. Use **Tools → Run Simulation Tool** for RTL simulation with ModelSim
