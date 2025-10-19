

// controller.v - controller for RISC-V CPU

module controller (
    input [6:0]  op,
    input [2:0]  funct3,
    input        funct7b5,
    input        Zero,
    input        ALUResult0,    // NEW: LSB of ALU result for branch comparisons
    output [1:0] ResultSrc,
    output       MemWrite,
    output       PCSrc, ALUSrc,
    output       RegWrite, Jump,
    output [1:0] ImmSrc,
    output [3:0] ALUControl     // Changed from [2:0] to [3:0]
);

wire [1:0] ALUOp;
wire       Branch, BranchTaken;

main_decoder    md (op, ResultSrc, MemWrite, Branch,
                    ALUSrc, RegWrite, Jump, ImmSrc, ALUOp);

alu_decoder     ad (op[5], funct3, funct7b5, ALUOp, ALUControl);

branch_logic    bl (funct3, Zero, ALUResult0, Branch, BranchTaken);

// PCSrc: take branch or jump
assign PCSrc = BranchTaken | Jump;

endmodule
