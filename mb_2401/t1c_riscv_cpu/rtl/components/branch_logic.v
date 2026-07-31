// =============================================================================
// Team ID    : 2401
// Theme      : MazeSolver Bot (MB)
// Authors    : Dibyendu Maity (not.dibyendu@gmail.com) and teams
// Filename   : branch_logic.v
// License    : MIT License (See LICENSE file in project root)
// =============================================================================
//
// Module Name : branch_logic
//
// Description : Branch condition evaluator for RISC-V RV32I.
//               Evaluates BEQ, BNE, BLT, BGE, BLTU, BGEU conditions using
//               ALU flags (Zero, ALUResult0) and funct3.
//
// Dependencies: None
// Target EDA  : Iverilog, GTKWave, Intel Quartus Prime, ModelSim
// Target HW   : Simulation / FPGA (Cyclone IV EP4CE22F17C6)
// =============================================================================

module branch_logic (
    input [2:0]  funct3,
    input        Zero,
    input        ALUResult0,
    input        Branch,
    output reg   PCSrc
);

// funct3: Input, 3-bit function field, selects the type of branch condition
// Zero: Input, flag from ALU (1 if ALU result was zero, used for BEQ/BNE)
// ALUResult0: Input, bit 0 of the ALU result (used for SLT/SLTU results, which output 1 or 0)
// Branch: Input, control signal, 1 if the current instruction is a branch
// PCSrc: Output, 1 if the branch is taken, 0 otherwise (controls PC multiplexer)


always @(*) begin
    /*
    Purpose:
    ---
    Combinational logic to determine the PCSrc output. If the 'Branch' 
    signal is low, no branch is taken (PCSrc=0). If 'Branch' is high, 
    it evaluates the specific branch condition using funct3 and ALU flags.
    */
    if (Branch) begin
        case (funct3)
            3'b000: PCSrc = Zero;           // BEQ: branch if Zero=1 (a==b)
            3'b001: PCSrc = ~Zero;          // BNE: branch if Zero=0 (a!=b)
            3'b100: PCSrc = ALUResult0;     // BLT: branch if SLT result=1 (a<b signed)
            3'b101: PCSrc = ~ALUResult0;    // BGE: branch if SLT result=0 (a>=b signed)
            3'b110: PCSrc = ALUResult0;     // BLTU: branch if SLTU result=1 (a<b unsigned)
            3'b111: PCSrc = ~ALUResult0;    // BGEU: branch if SLTU result=0 (a>=b unsigned)
            default: PCSrc = 1'b0;
        endcase
    end else begin
        PCSrc = 1'b0;
    end
end

endmodule
