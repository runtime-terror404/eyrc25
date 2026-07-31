// =============================================================================
// Team ID    : 2401
// Theme      : MazeSolver Bot (MB)
// Authors    : Dibyendu Maity (not.dibyendu@gmail.com) and teams
// Filename   : imm_extend.v
// License    : MIT License (See LICENSE file in project root)
// =============================================================================
//
// Module Name : imm_extend
//
// Description : Immediate extension unit for RISC-V RV32I.
//               Generates 32-bit sign-extended immediates for I, S, B, J,
//               and U-type instruction formats based on immsrc select.
//
// Dependencies: None
// Target EDA  : Iverilog, GTKWave, Intel Quartus Prime, ModelSim
// Target HW   : Simulation / FPGA (Cyclone IV EP4CE22F17C6)
// =============================================================================

module imm_extend (
    input  [31:0]     instr,
    input  [ 1:0]     immsrc,
    output reg [31:0] immext
);

// instr: Input, the 32-bit instruction word
// immsrc: Input, 2-bit control signal selecting the immediate format
// immext: Output, the 32-bit sign-extended immediate value

always @(*) begin
    /*
    Purpose:
    ---
    Combinational logic to select and construct the correct sign-extended 
    immediate value (immext) based on the instruction format, 
    which is specified by the immsrc signal.
    */
    case(immsrc)
        // I-type
        2'b00: immext = {{20{instr[31]}}, instr[31:20]};
        
        // S-type (stores)
        2'b01: immext = {{20{instr[31]}}, instr[31:25], instr[11:7]};
        
        // B-type (branches)
        2'b10: immext = {{20{instr[31]}}, instr[7], instr[30:25], instr[11:8], 1'b0};
        
        // J-type (jal) and U-type (lui, auipc)
        2'b11: begin
            if (instr[3]) // J-type: jal has bit 3 = 1 in opcode (1101111)
                immext = {{12{instr[31]}}, instr[19:12], instr[20], instr[30:21], 1'b0};
            else // U-type: lui/auipc have bit 3 = 0 in opcode (0110111, 0010111)
                immext = {instr[31:12], 12'b0};
        end
        
        default: immext = 32'bx;
    endcase
end

endmodule
