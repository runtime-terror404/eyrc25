# t1b_ultrasonic_controller — HC-SR04 Ultrasonic Distance Sensor

A controller for the HC-SR04 ultrasonic distance sensor. Uses a 4-state FSM to generate the 10µs trigger pulse, measure the echo pulse width, and calculate distance in millimeters. Includes timeout protection and configurable obstacle detection threshold.

## Directory Structure

```
t1b_ultrasonic_controller/
├── Makefile                     # Build automation for Iverilog simulation
├── t1b_ultrasonic.qpf           # Quartus Prime project file
├── t1b_ultrasonic.qsf           # Quartus settings file (pin assignments, device)
├── rtl/
│   └── t1b_ultrasonic.v         # HC-SR04 ultrasonic sensor controller
└── tb/
    └── tb.v                     # Testbench (e-Yantra provided)
```

## Finite State Machine

```
 S_INIT_DELAY ──► S_TRIG_PULSE ──► S_MEASURE_ECHO ──► S_CYCLE_DELAY
      ▲                                                      │
      └──────────────────────────────────────────────────────┘
                          (12ms cycle)
```

| State | Duration | Action |
|-------|----------|--------|
| `S_INIT_DELAY` | 1µs | Sensor settling time |
| `S_TRIG_PULSE` | 10µs | Drive TRIG pin HIGH |
| `S_MEASURE_ECHO` | Variable | Measure echo pulse width |
| `S_CYCLE_DELAY` | ~60ms | Wait for next measurement cycle |

## About

| | |
|---|---|
| **Module** | `t1b_ultrasonic` |
| **Inputs** | `clk_50M`, `reset` (active-low), `echo_rx` |
| **Outputs** | `trig`, `op` (obstacle detected), `distance_out[15:0]` (mm) |
| **Threshold** | 70mm (configurable via `OBSTACLE_THRESHOLD`) |
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
2. **File → Open Project** → select `t1b_ultrasonic.qpf`
3. **Processing → Start Compilation** to synthesize
4. Use **Tools → Run Simulation Tool** for RTL simulation with ModelSim
