#!/bin/bash
# =============================================================================
# Team ID    : 2401
# Theme      : MazeSolver Bot (MB)
# Authors    : Dibyendu Maity (not.dibyendu@gmail.com) and teams
# Filename   : generatehex.sh
# License    : MIT License (See LICENSE file in project root)
# =============================================================================
#
# Description : Compiles a C source file into RISC-V binary and converts it
#               to Verilog hex format for loading into the instruction memory
#               of the t1c_riscv_cpu.
#
# Usage       : ./generatehex.sh [input.c]
#               (defaults to blink-compiler-test.c if no argument given)
#
# Dependencies: riscv64-unknown-elf-gcc, objdump, objcopy, truncate
# Target Arch : RV32IM
# =============================================================================

[ ! -z "${1}" ] && infile="${1}" || infile="blink-compiler-test.c"

ARCH=rv32im
ROM=2048
RAM=256
STACK=64

CFLAGS="  -march=$ARCH -mabi=ilp32 --specs=picolibc.specs -Os -g3 -flto -DPICOLIBC_INTEGER_PRINTF_SCANF -Wall"
LDFLAGS=" -march=$ARCH -mabi=ilp32 --specs=picolibc.specs -Os -g3 -flto -DPICOLIBC_INTEGER_PRINTF_SCANF "
LDFLAGS+=" -Wl,--gc-sections,--defsym=__flash=0x01000000,--defsym=__flash_size=$ROM --crt0=minimal" #" -nostartfiles"
LDFLAGS+=" -Wl,--defsym=__ram=0x02000000,--defsym=__ram_size=$RAM,--defsym=__stack_size=$STACK -Tpicolibc.ld"

riscv64-unknown-elf-gcc $CFLAGS -c "$infile" -o .temp.file.o && \
riscv64-unknown-elf-gcc $LDFLAGS -o .temp.file.elf .temp.file.o && \
riscv64-unknown-elf-objdump --visualize-jumps -t -S --source-comment='     ### ' .temp.file.elf -M no-aliases,numeric > listing.lss && \
riscv64-unknown-elf-objcopy -O binary .temp.file.elf .temp.file.bin && \
truncate -s $ROM .temp.file.bin && \
riscv64-unknown-elf-objcopy --verilog-data-width=4 --reverse-bytes=4 -I binary -O verilog .temp.file.bin output.hex && \
riscv64-unknown-elf-size -B --common .temp.file.elf && \
echo "output.hex and listing.lss have been successfully generated from $infile"  || \
echo "And therefore, $infile could not be converted into binary format. :(" 

rm -f .temp.file.*
