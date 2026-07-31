// =============================================================================
// Team ID    : 2401
// Theme      : MazeSolver Bot (MB)
// Authors    : Dibyendu Maity (not.dibyendu@gmail.com) and teams
// Filename   : blink-compiler-test.c
// License    : MIT License (See LICENSE file in project root)
// =============================================================================
//
// Description : LED blinker test program for RISC-V CPU.
//               Toggles an LED pattern with delay loops to verify the RISC-V
//               GCC toolchain can correctly compile and link code targeting
//               the custom RV32IM CPU.
//
// Dependencies: RISC-V GCC toolchain (riscv64-unknown-elf-gcc)
// Target Arch : RV32IM
// =============================================================================

// Slow LED blinker (for hardware implementation)

// For definition of uint32_t
#include <stdint.h>

// Memory mapped address of LED peripheral
#define LED    (*(volatile uint32_t  *) 0x20000004)

int main() {
    // Set initial value for led
    LED = 0b01010101010101010101010101010101;
    
    // Toggle LED indefinitely with delay
    while(1) {
        LED = ~LED;
        
        // Delay loop
        for(int i=0; i<0x100000; i++)
            asm volatile("nop");
        
        // used assembly nop instruction to prevent
        // compiler from optimizing out our loop
    }
    
    // Won't reach here
    return 0;
}
