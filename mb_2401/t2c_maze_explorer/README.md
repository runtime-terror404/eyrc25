# t2c_maze_explorer — Autonomous Maze Navigation

The autonomous navigation controller for the MazeSolver Bot. Implements a depth-first search (DFS) based algorithm with stack-based backtracking to navigate a 9×9 warehouse-like maze from a known start position to an exit, using three wall sensors (left, middle, right).

## Directory Structure

```
t2c_maze_explorer/
├── Makefile                     # Build automation for Iverilog simulation
├── t2c_maze_explorer.qpf        # Quartus Prime project file
├── t2c_maze_explorer.qsf        # Quartus settings file (pin assignments, device)
├── rtl/
│   └── t2c_maze_explorer.v      # Maze navigation FSM with DFS + backtracking
└── tb/
    └── tb.v                     # Testbench (e-Yantra provided)
```

## Algorithm

A depth-first search (DFS) approach with a hardware stack for junction backtracking:

1. **Sensor Mapping** — Relative wall sensors (left/mid/right) are mapped to absolute compass directions (N/E/S/W) based on the bot's current facing
2. **Corridor Following** — In simple corridors, the bot follows `mid > left > right` priority
3. **Junction Detection** — When multiple paths are open, the bot pushes its current position and tried directions onto a stack, then follows the preferred path
4. **Dead End Handling** — All three walls present → U-turn and increment dead-end counter
5. **Backtracking** — Returns to saved junctions and tries unexplored paths
6. **Exit Detection** — At position (4,0) facing North with no middle wall → exit reached

### Movement Commands

| cmd | move | meaning |
|-----|------|---------|
| 000 | 0 | STOP |
| 001 | 1 | FORWARD |
| 010 | 2 | LEFT |
| 011 | 3 | RIGHT |
| 100 | 4 | U-TURN |

## About

| | |
|---|---|
| **Module** | `t2c_maze_explorer` |
| **Inputs** | `clk`, `rst_n` (active-low), `left`, `mid`, `right` |
| **Outputs** | `move[2:0]` (3-bit movement command) |
| **Algorithm** | DFS with stack-based backtracking |
| **Maze** | 9×9 grid (81 positions), 9 dead ends |
| **Start** | Position 76 (4,0), facing North |
| **Exit** | Position 4 (4,8), facing North |
| **Target FPGA** | Cyclone IV EP4CE22F17C6 |
| **Tested on** | Intel Quartus Prime 20.1 Lite Edition |

> **Note:** This DFS implementation is not the most optimal search algorithm
> for this maze. It explores all dead ends but may not pass every testbench
> check case. The algorithm successfully navigates the maze but room for
> improvement remains in path optimization and edge-case handling.

## Quick Simulation (Iverilog + GTKWave)

> **⚠️ Iverilog Limitations:** This project's testbench uses SystemVerilog
> features not fully supported by Iverilog (Verilog-2001/2005 only).
> Use **Intel Quartus Prime 20.1 / ModelSim** — the authoritative simulation
> environment used by e-Yantra — for accurate results.

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
2. **File → Open Project** → select `t2c_maze_explorer.qpf`
3. **Processing → Start Compilation** to synthesize
4. Use **Tools → Run Simulation Tool** for RTL simulation with ModelSim
