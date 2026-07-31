# t2a_dht_controller — DHT11 Temperature & Humidity Sensor Controller

A controller for the DHT11 digital temperature and humidity sensor. Uses a 9-state Finite State Machine to implement the complete DHT11 single-wire communication protocol including start signal generation, sensor response detection, 40-bit data frame reception, and checksum validation.

## Directory Structure

```
t2a_dht_controller/
├── Makefile              # Build automation for Iverilog simulation
├── t2a_dht.qpf           # Quartus Prime project file
├── t2a_dht.qsf           # Quartus settings file (pin assignments, device)
├── rtl/
│   └── t2a_dht.v         # DHT11 sensor controller FSM
└── tb/
    └── tb.v              # Testbench (e-Yantra provided)
```

## Finite State Machine

```
 S_IDLE ──► S_REQ_LOW ──► S_REQ_HIGH ──► S_RELEASE ──► S_RESP_LOW ──► S_RESP_HIGH
    ▲                                                                           │
    │         ┌─────────────────────────────────────────────────────────────────┘
    │         ▼
    └── S_FINISH ◄── S_BIT_HIGH ◄── S_BIT_LOW (×40 bits)
```

| State | Duration | Action |
|-------|----------|--------|
| `S_IDLE` | 1 cycle | Prepare start signal |
| `S_REQ_LOW` | 18ms | Pull line LOW (start signal) |
| `S_REQ_HIGH` | 40µs | Pull line HIGH |
| `S_RELEASE` | Variable | Release line, wait for sensor |
| `S_RESP_LOW` | ~80µs | Sensor pulls LOW (response) |
| `S_RESP_HIGH` | ~80µs | Sensor pulls HIGH (ready) |
| `S_BIT_LOW` | 50µs/bit | Wait for rising edge |
| `S_BIT_HIGH` | Variable | Measure HIGH pulse (26µs=0, 70µs=1) |
| `S_FINISH` | 2 cycles | Validate checksum, output data |

## About

| | |
|---|---|
| **Module** | `t2a_dht` |
| **Inputs** | `clk_50M`, `reset` (active-low) |
| **Inouts** | `sensor` (bidirectional data line) |
| **Outputs** | `T_integral`, `T_decimal`, `RH_integral`, `RH_decimal`, `Checksum`, `data_valid` |
| **Data Format** | 40-bit frame: RH(16) + Temp(16) + Checksum(8) |
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
2. **File → Open Project** → select `t2a_dht.qpf`
3. **Processing → Start Compilation** to synthesize
4. Use **Tools → Run Simulation Tool** for RTL simulation with ModelSim
