# =============================================================================
# Project     : t0c_sequence_detector
# Team ID     : 2401
# Theme       : MazeSolver Bot (MB)
# Description : Makefile for Iverilog + GTKWave simulation
# =============================================================================

# --- Sources ---
RTL_SRC  = $(wildcard rtl/*.v)
TB_SRC   = $(wildcard tb/*.v)

# --- Top-level testbench module ---
TOP      = tb

# --- Output ---
VCD      = dump.vcd
OUT      = $(TOP).out

# --- Tools ---
IVERILOG = iverilog
VVP      = vvp
GTKWAVE  = gtkwave

# --- Flags ---
IVERILOG_FLAGS = -g2012 -o $(OUT)

# =============================================================================
# Targets
# =============================================================================

.PHONY: all sim wave clean

all: sim

sim: $(OUT)
	$(VVP) $(OUT)

$(OUT): $(RTL_SRC) $(TB_SRC)
	$(IVERILOG) $(IVERILOG_FLAGS) -s $(TOP) $(RTL_SRC) $(TB_SRC)

wave: sim
	$(GTKWAVE) $(VCD) &

clean:
	rm -f $(OUT) $(VCD)
