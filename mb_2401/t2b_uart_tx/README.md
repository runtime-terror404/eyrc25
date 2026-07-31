# t2b_uart_tx — UART Transmitter (115200 Baud)

A UART (Universal Asynchronous Receiver-Transmitter) transmitter with configurable even/odd parity. Serializes 8-bit parallel data into an 11-bit frame (start + 8 data + parity + stop) for asynchronous serial transmission at 115200 baud from a 3.125MHz clock.

## Directory Structure

```
t2b_uart_tx/
├── Makefile              # Build automation for Iverilog simulation
├── uart_tx.qpf           # Quartus Prime project file
├── uart_tx.qsf           # Quartus settings file (pin assignments, device)
├── rtl/
│   └── uart_tx.v         # UART transmitter FSM
└── tb/
    └── tb.v              # Testbench (e-Yantra provided)
```

## Frame Format

```
┌──────┬──────────┬───────────┬────────┬──────┐
│ Bit  │    0     │   1-8     │   9    │  10  │
├──────┼──────────┼───────────┼────────┼──────┤
│      │ Start (0)│ Data LSB→ │ Parity │ Stop │
│      │          │   MSB     │ (even/ │  (1) │
│      │          │           │  odd)  │      │
└──────┴──────────┴───────────┴────────┴──────┘
```

## About

| | |
|---|---|
| **Module** | `uart_tx` |
| **Inputs** | `clk_3125` (3.125MHz), `parity_type` (0=even/1=odd), `tx_start`, `data[7:0]` |
| **Outputs** | `tx`, `tx_done` |
| **Baud Rate** | 115200 (27 clocks/bit at 3.125MHz) |
| **Parity** | Configurable: even or odd |
| **Target FPGA** | Cyclone IV EP4CE22F17C6 |
| **Tested on** | Intel Quartus Prime 20.1 Lite Edition |

## Quick Simulation (Iverilog + GTKWave)

> **⚠️ Iverilog Limitations:** This project's testbench uses SystemVerilog
> indexed part-select (`[base+:width]`) and delay assignments (`assign #(1,1)`),
> which are not supported by Iverilog (Verilog-2001/2005 only). Use **Intel
> Quartus Prime 20.1 / ModelSim** — the authoritative simulation environment
> used by e-Yantra — where this design was **verified and passed all testbench
> checks**. The Makefile is provided for quick iteration on RTL changes only.

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
2. **File → Open Project** → select `uart_tx.qpf`
3. **Processing → Start Compilation** to synthesize
4. Use **Tools → Run Simulation Tool** for RTL simulation with ModelSim
