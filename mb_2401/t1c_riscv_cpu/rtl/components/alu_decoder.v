// =============================================================================
// Team ID    : 2401
// Theme      : MazeSolver Bot (MB)
// Authors    : Dibyendu Maity (not.dibyendu@gmail.com) and teams
// Filename   : alu_decoder.v
// License    : MIT License (See LICENSE file in project root)
// =============================================================================
//
// Module Name : alu_decoder
//
// Description : ALU control decoder for RISC-V RV32I.
//               Decodes ALUOp, funct3, funct7b5, and opb5 to generate the
//               4-bit ALUControl signal for the ALU.
//
// Dependencies: None
// Target EDA  : Iverilog, GTKWave, Intel Quartus Prime, ModelSim
// Target HW   : Simulation / FPGA (Cyclone IV EP4CE22F17C6)
// =============================================================================

module alu_decoder (
    input            opb5,
    input [2:0]      funct3,
    input            funct7b5,
    input [1:0]      ALUOp,
    output reg [3:0] ALUControl
);

// opb5: Input, typically opcode[5], helps differentiate instruction types (e.g., R-type vs I-type)
// funct3: Input, 3-bit function field from the instruction
// funct7b5: Input, bit 5 of the 7-bit function field (funct7), helps differentiate ADD/SUB and SRL/SRA
// ALUOp: Input, 2-bit primary control signal from the Main Decoder
// ALUControl: Output, 4-bit control signal for the ALU (e.g., 0000=ADD, 0001=SUB)

always @(*) begin
    /*
    Purpose:
    ---
    < Combinational logic to determine the ALUControl output signal based on 
      the instruction fields (ALUOp, funct3, funct7b5, opb5). >
    */
    case (ALUOp)
        2'b00: ALUControl = 4'b0000;             // addition (for load/store)
        
        2'b01: begin                             // branch operations
            case (funct3)
                3'b000: ALUControl = 4'b0001;    // BEQ: subtract
                3'b001: ALUControl = 4'b0001;    // BNE: subtract
                3'b100: ALUControl = 4'b0101;    // BLT: SLT (signed)
                3'b101: ALUControl = 4'b0101;    // BGE: SLT (signed)
                3'b110: ALUControl = 4'b0110;    // BLTU: SLTU (unsigned)
                3'b111: ALUControl = 4'b0110;    // BGEU: SLTU (unsigned)
                default: ALUControl = 4'b0001;   // default: subtract
            endcase
        end
        
        default: begin                           // ALUOp = 2'b10: R-type or I-type ALU
            case (funct3)
                3'b000: begin
                    if (funct7b5 & opb5) 
                        ALUControl = 4'b0001;    // SUB
                    else 
                        ALUControl = 4'b0000;    // ADD/ADDI
                end
                3'b001: ALUControl = 4'b0111;    // SLL/SLLI
                3'b010: ALUControl = 4'b0101;    // SLT/SLTI
                3'b011: ALUControl = 4'b0110;    // SLTU/SLTIU
                3'b100: ALUControl = 4'b0100;    // XOR/XORI
                3'b101: begin
                    if (funct7b5) 
                        ALUControl = 4'b1001;    // SRA/SRAI
                    else 
                        ALUControl = 4'b1000;    // SRL/SRLI
                end
                3'b110: ALUControl = 4'b0011;    // OR/ORI
                3'b111: ALUControl = 4'b0010;    // AND/ANDI
                default: ALUControl = 4'bxxxx;
            endcase
        end
    endcase
end

endmodule
