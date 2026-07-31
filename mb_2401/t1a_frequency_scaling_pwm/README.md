# t1a_frequency_scaling_pwm — Frequency Scaling & PWM Generator

A two-stage clock divider and PWM generator. The 50MHz system clock is first divided to 3.125MHz, then to 195KHz, which drives a 4-bit PWM controller with configurable duty cycle (0–15 steps).

## Directory Structure

```
t1a_frequency_scaling_pwm/
├── Makefile                     # Build automation for Iverilog simulation
├── t1a_fs_pwm.qpf               # Quartus Prime project file
├── t1a_fs_pwm.qsf               # Quartus settings file (pin assignments, device)
├── frequency_scaling.bsf        # Block symbol file (Quartus)
├── pwm_generator.bsf            # Block symbol file (Quartus)
├── rtl/
│   ├── frequency_scaling.v      # Clock divider: 50MHz → 3.125MHz (÷16)
│   ├── pwm_generator.v          # PWM + clock divider: 3.125MHz → 195KHz (÷16)
│   ├── t1a_fs_pwm.bdf           # Quartus block diagram (schematic)
│   └── t1a_fs_pwm_bdf.v         # Auto-generated top-level from .bdf
└── tb/
    └── tb.v                     # Testbench (e-Yantra provided)
```

## Architecture

```
clk_50M ──► [frequency_scaling] ──► clk_3125KHz ──► [pwm_generator] ──► clk_195KHz
                                            │                            │
                                            │                            └──► pwm_signal
                                            │
                               duty_cycle[3:0] ────────────────────────────┘
```

| Stage | Input | Output | Divide Ratio |
|-------|-------|--------|-------------|
| frequency_scaling | 50 MHz | 3.125 MHz | ÷16 |
| pwm_generator (clk) | 3.125 MHz | 195 KHz | ÷16 |
| pwm_generator (PWM) | — | pwm_signal | 0–15 / 16 steps |

## About

| | |
|---|---|
| **Top Module** | `t1a_fs_pwm_bdf` |
| **Sub-modules** | `frequency_scaling`, `pwm_generator` |
| **Inputs** | `clk_50M`, `duty_cycle[3:0]` |
| **Outputs** | `pwm_signal`, `clk_195KHz`, `clk_3125KHz` |
| **Target FPGA** | Cyclone IV EP4CE22F17C6 |
| **Tested on** | Intel Quartus Prime 20.1 Lite Edition |

## Quick Simulation (Iverilog + GTKWave)

> **⚠️ Known Simulator Difference:** Iverilog may report timing mismatches
> ("Error(s) encountered") due to delta-cycle resolution differences between
> Iverilog and ModelSim. This design was **verified and passed all testbench
> checks** on Intel Quartus Prime 20.1 / ModelSim — the authoritative simulation
> environment used by e-Yantra. Iverilog + GTKWave is provided for
> convenience (quick waveform viewing) only; trust ModelSim results for
> formal verification.

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
2. **File → Open Project** → select `t1a_fs_pwm.qpf`
3. The block diagram (.bdf) is the top-level design
4. **Processing → Start Compilation** to synthesize
5. Use **Tools → Run Simulation Tool** for RTL simulation with ModelSim
