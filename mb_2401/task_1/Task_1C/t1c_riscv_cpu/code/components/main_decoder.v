/*
# Team ID:          2401
# Theme:            MazeSolver Bot (MB)
# Author List:      Dibyendu Maity,Ankit Dwibedi,Sankalpa Basak,Snehajit Paul
# Filename:         main_decoder.v
# File Description: This module is the main control unit decoder. It generates the primary control signals for the datapath based on the instruction's 7-bit opcode.
# Global variables: None
*/

module main_decoder (
    input  [6:0] op,
    output [1:0] ResultSrc,
    output       MemWrite, Branch, ALUSrc,
    output       RegWrite, Jump,
    output [1:0] ImmSrc,
    output [1:0] ALUOp
);

// op: Input, the 7-bit opcode field from the instruction
// ResultSrc: Output, selects data for register write-back (ALU, Mem, PC+4, etc.)
// MemWrite: Output, control signal, 1 to enable writing to data memory (for stores)
// Branch: Output, control signal, 1 if the instruction is a branch
// ALUSrc: Output, control signal, 1 to select immediate as the ALU's second operand
// RegWrite: Output, control signal, 1 to enable writing to the register file
// Jump: Output, control signal, 1 if the instruction is JAL or JALR
// ImmSrc: Output, 2-bit control signal for the immediate generation unit
// ALUOp: Output, 2-bit control signal for the ALU decoder (specifies operation type)

// controls: Internal register holding the 11-bit concatenated control signals
reg [10:0] controls;

always @(*) begin
    case (op)
        // Control signals: RegWrite_ImmSrc_ALUSrc_MemWrite_ResultSrc_Branch_ALUOp_Jump
        7'b0000011: controls = 11'b1_00_1_0_01_0_00_0; // lw, lh, lb, lhu, lbu
        7'b0100011: controls = 11'b0_01_1_1_00_0_00_0; // sw, sh, sb
        7'b0110011: controls = 11'b1_xx_0_0_00_0_10_0; // R-type
        7'b1100011: controls = 11'b0_10_0_0_00_1_01_0; // beq, bne, blt, bge, bltu, bgeu
        7'b0010011: controls = 11'b1_00_1_0_00_0_10_0; // I-type ALU
        7'b1101111: controls = 11'b1_11_0_0_10_0_00_1; // jal
        7'b1100111: controls = 11'b1_00_1_0_10_0_00_1; // jalr
        7'b0110111: controls = 11'b1_11_x_0_11_0_00_0; // lui 
        7'b0010111: controls = 11'b1_11_x_0_11_0_00_0; // auipc 
        default:    controls = 11'bx_xx_x_x_xx_x_xx_x;
    endcase
end

// Assign the bits from the 'controls' vector to the respective output ports
assign {RegWrite, ImmSrc, ALUSrc, MemWrite, ResultSrc, Branch, ALUOp, Jump} = controls;

endmodule
