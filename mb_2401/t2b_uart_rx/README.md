# t2b_uart_rx — UART Receiver (115200 Baud)

A UART (Universal Asynchronous Receiver-Transmitter) receiver with even parity checking. Uses a 5-state Finite State Machine to sample the asynchronous serial input line, deserialize 8 data bits, verify even parity, and validate the stop bit. Configured for 115200 baud from a 3.125MHz clock.

## Directory Structure

```
t2b_uart_rx/
├── Makefile              # Build automation for Iverilog simulation
├── uart_rx.qpf           # Quartus Prime project file
├── uart_rx.qsf           # Quartus settings file (pin assignments, device)
├── rtl/
│   └── uart_rx.v         # UART receiver FSM
└── tb/
    └── tb.v              # Testbench (e-Yantra provided)
```

## Finite State Machine

```
         ┌──────────────────────────────────┐
         │                                   │
  IDLE ──► START_BIT ──► DATA_BITS (×8) ──► PARITY_BIT ──► STOP_BIT
    ▲                                                        │
    └────────────────────────────────────────────────────────┘
```

| State | Action |
|-------|--------|
| `IDLE` | Wait for start bit (rx falling edge) |
| `START_BIT` | Verify start bit at midpoint |
| `DATA_BITS` | Sample 8 data bits (LSB first) |
| `PARITY_BIT` | Sample even parity bit |
| `STOP_BIT` | Validate stop bit, output result |

## About

| | |
|---|---|
| **Module** | `uart_rx` |
| **Inputs** | `clk_3125` (3.125MHz), `rx` |
| **Outputs** | `rx_msg[7:0]`, `rx_parity`, `rx_complete` |
| **Baud Rate** | 115200 (27 clocks/bit at 3.125MHz) |
| **Parity** | Even parity; outputs `?` (0x3F) on error |
| **Target FPGA** | Cyclone IV EP4CE22F17C6 |
| **Tested on** | Intel Quartus Prime 20.1 Lite Edition |

## Quick Simulation (Iverilog + GTKWave)

> **⚠️ Iverilog Limitations:** This project's testbench uses SystemVerilog
> streaming concatenation (`{<<{}}`) for bit-reversal, which is not supported
> by Iverilog (Verilog-2001/2005 only). Use **Intel Quartus Prime 20.1 /
> ModelSim** — the authoritative simulation environment used by e-Yantra —
> where this design was **verified and passed all testbench checks**.
> The Makefile is provided for quick iteration on RTL changes only.

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
2. **File → Open Project** → select `uart_rx.qpf`
3. **Processing → Start Compilation** to synthesize
4. Use **Tools → Run Simulation Tool** for RTL simulation with ModelSim
