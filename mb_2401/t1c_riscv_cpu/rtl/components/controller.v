// =============================================================================
// Team ID    : 2401
// Theme      : MazeSolver Bot (MB)
// Authors    : Dibyendu Maity (not.dibyendu@gmail.com) and teams
// Filename   : controller.v
// License    : MIT License (See LICENSE file in project root)
// =============================================================================
//
// Module Name : controller
//
// Description : Top-level control unit for the single-cycle RISC-V RV32I CPU.
//               Instantiates main_decoder, alu_decoder, and branch_logic to
//               generate all control signals for the datapath.
//
// Dependencies: main_decoder.v, alu_decoder.v, branch_logic.v
// Target EDA  : Iverilog, GTKWave, Intel Quartus Prime, ModelSim
// Target HW   : Simulation / FPGA (Cyclone IV EP4CE22F17C6)
// =============================================================================

module controller (
    input [6:0]  op,
    input [2:0]  funct3,
    input        funct7b5,
    input        Zero,
    input        ALUResult0,    
    output [1:0] ResultSrc,
    output       MemWrite,
    output       PCSrc, ALUSrc,
    output       RegWrite, Jump,
    output [1:0] ImmSrc,
    output [3:0] ALUControl     
);

// op: Input, the 7-bit opcode field from the instruction
// funct3: Input, the 3-bit funct3 field from the instruction
// funct7b5: Input, bit 5 of the funct7 field (used by alu_decoder)
// Zero: Input, flag from ALU (1 if ALU result is zero)
// ALUResult0: Input, LSB of ALU result (used for SLT/BLT comparisons)
// ResultSrc: Output, selects the data to be written back to the register file (e.g., ALU result or data from memory)
// MemWrite: Output, control signal, 1 to enable writing to data memory
// PCSrc: Output, control signal, 1 to select the branch/jump target address for the PC
// ALUSrc: Output, control signal, selects the second operand for the ALU (register or immediate)
// RegWrite: Output, control signal, 1 to enable writing to the register file
// Jump: Output, control signal, 1 if the instruction is a JAL or JALR
// ImmSrc: Output, selects the immediate generation format (I-type, S-type, etc.)
// ALUControl: Output, 4-bit control signal for the ALU operation

wire [1:0] ALUOp;
wire       Branch, BranchTaken;

// ALUOp: Internal wire, 2-bit signal from main_decoder to alu_decoder
// Branch: Internal wire, 1-bit signal from main_decoder, 1 if the instruction is a branch
// BranchTaken: Internal wire, 1-bit signal from branch_logic, 1 if the branch condition is met

main_decoder    md (op, ResultSrc, MemWrite, Branch,
                    ALUSrc, RegWrite, Jump, ImmSrc, ALUOp);

alu_decoder     ad (op[5], funct3, funct7b5, ALUOp, ALUControl);

branch_logic    bl (funct3, Zero, ALUResult0, Branch, BranchTaken);

// PCSrc: take branch or jump
assign PCSrc = BranchTaken | Jump;

endmodule
