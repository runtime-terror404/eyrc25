# MazeSolver Bot — e-Yantra Robotics Competition 2025

**Team #2401** | Maulana Abul Kalam Azad University of Technology (MAKAUT), West Bengal

An FPGA-powered autonomous maze-solving robot built for the **e-Yantra Robotics Competition 2025** organized by IIT Bombay. The bot navigates a warehouse-like grid, collects environmental sensor data (temperature, humidity, distance), and communicates over UART — all driven by a custom-designed **single-cycle RISC-V RV32I CPU** implemented in Verilog HDL.

---

## Project Overview

The MazeSolver Bot (MB) theme challenges teams to build an autonomous FPGA robot from the ground up. Our implementation covers:

- **Custom RISC-V CPU** — 17-module single-cycle processor implementing the full RV32I instruction set
- **Sensor Integration** — DHT11 temperature/humidity, HC-SR04 ultrasonic distance, wall proximity sensors
- **Communication** — UART transmitter and receiver with configurable parity (115200 baud)
- **Autonomous Navigation** — DFS-based maze exploration with stack backtracking and dead-end detection
- **Peripheral Control** — PWM generation with frequency scaling for motor/servo control

---

## Repository Structure

```
eyrc25/
├── LICENSE                    # MIT License (code) + e-Yantra attribution
├── README.md
└── mb_2401/
    ├── t0a_and_gate/                  # Basic AND gate
    ├── t0b_ripple_carry_adder/        # 2-bit ripple carry adder
    ├── t0c_sequence_detector/         # "1094" sequence detector FSM
    ├── t0d_riscv_compiler_test/       # RISC-V GCC toolchain verification
    ├── t1a_frequency_scaling_pwm/     # Clock divider + PWM generator
    ├── t1b_ultrasonic_controller/     # HC-SR04 ultrasonic sensor controller
    ├── t1c_riscv_cpu/                 # Single-cycle RISC-V RV32I CPU
    ├── t2a_dht_controller/            # DHT11 temperature & humidity sensor
    ├── t2b_uart_rx/                   # UART receiver (115200 baud)
    ├── t2b_uart_tx/                   # UART transmitter (115200 baud)
    └── t2c_maze_explorer/             # Autonomous maze navigation (DFS)
```

Each project directory is self-contained with RTL source, testbench, Makefile, and its own README.

---

## Technology Stack

| | |
|---|---|
| **HDL** | Verilog (IEEE 1364-2001) |
| **Design & Synthesis** | Intel Quartus Prime 20.1 Lite Edition |
| **Simulation** | ModelSim (Quartus), Iverilog + GTKWave |
| **Processor** | Custom RISC-V RV32I (single-cycle, Harvard) |
| **Target FPGA** | Cyclone IV EP4CE22F17C6 |
| **Toolchain** | RISC-V GNU GCC (riscv64-unknown-elf) |

---

## Quick Start

Every project directory supports:

```bash
make          # Compile and run simulation with Iverilog
make wave     # View waveforms in GTKWave
make clean    # Remove generated files
```

For Quartus, open the `.qpf` file in Intel Quartus Prime 20.1 Lite Edition.

> **Note:** Some testbenches use SystemVerilog features not supported by Iverilog. Use ModelSim (via Quartus) for authoritative simulation results. See individual project READMEs for details.

---

## About e-Yantra

[e-Yantra](https://portal.e-yantra.org/) is a robotics competition hosted by the **Indian Institute of Technology Bombay (IIT Bombay)**. It is a project-based learning initiative that nurtures engineering talent through hands-on experience in solving real-world problems with embedded systems, digital logic design, and robotics.

---

## Team

- **Dibyendu Maity** — [not.dibyendu@gmail.com](mailto:not.dibyendu@gmail.com)
- **Ankit Dwibedi**
- **Sankalpa Basak**
- **Snehajit Paul**

MAKAUT, West Bengal

---

## License

The original Verilog RTL source code, scripts, and documentation in this repository are licensed under the **MIT License**. See [LICENSE](LICENSE) for the full text.

The e-Yantra competition theme ("MazeSolver Bot"), problem statements, specifications, evaluation criteria, and organizer-provided testbench files (contained within `tb/` directories) are the intellectual property of **e-Yantra, IIT Bombay** and are included for reference and educational purposes only.
