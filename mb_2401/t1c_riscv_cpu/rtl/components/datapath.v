// =============================================================================
// Team ID    : 2401
// Theme      : MazeSolver Bot (MB)
// Authors    : Dibyendu Maity (not.dibyendu@gmail.com) and teams
// Filename   : datapath.v
// License    : MIT License (See LICENSE file in project root)
// =============================================================================
//
// Module Name : datapath
//
// Description : Main datapath for the single-cycle RISC-V RV32I CPU.
//               Contains PC (with reset_ff), register file, immediate
//               extender, ALU, load extension logic, and all multiplexers.
//               Supports JALR target computation inline.
//
// Dependencies: adder.v, reset_ff.v, mux2.v, mux4.v, reg_file.v,
//               imm_extend.v, alu.v
// Target EDA  : Iverilog, GTKWave, Intel Quartus Prime, ModelSim
// Target HW   : Simulation / FPGA (Cyclone IV EP4CE22F17C6)
// =============================================================================

module datapath (
    // Control Inputs
    input         clk, reset,
    input [1:0]   ResultSrc,
    input         PCSrc, ALUSrc,
    input         RegWrite,
    input [1:0]   ImmSrc,
    input [3:0]   ALUControl,

    // ALU Flag Outputs
    output        Zero,

    // PC and Instruction Memory Interface
    output [31:0] PC,
    input  [31:0] Instr,

    // Data Memory Interface
    output [31:0] Mem_WrAddr, Mem_WrData,
    input  [31:0] ReadData,

    // Writeback
    output [31:0] Result,

    // ALU Flag Outputs
    output        ALUResult0
);

// Internal Wires
wire [31:0] PCNext, PCPlus4, PCTarget;
wire [31:0] ImmExt, SrcA, SrcB, WriteData, ALUResult;
wire [31:0] UpperImm;
reg  [31:0] ReadDataExt;

// ReadDataExt: Holds the sign-extended or zero-extended data from memory for loads
// JALR: Internal wire, high when the instruction is JALR

// Inline load extension logic
always @(*) begin
    /*
    Purpose:
    ---
    Combinational logic to sign-extend or zero-extend the data read
    from memory (ReadData) based on the load instruction type (funct3).
    This handles LB, LH, LW, LBU, and LHU.
    */
    case (Instr[14:12]) // funct3 field for load instructions
        3'b000: ReadDataExt = {{24{ReadData[7]}}, ReadData[7:0]};      // LB
        3'b001: ReadDataExt = {{16{ReadData[15]}}, ReadData[15:0]};    // LH
        3'b010: ReadDataExt = ReadData;                                 // LW
        3'b100: ReadDataExt = {24'b0, ReadData[7:0]};                   // LBU
        3'b101: ReadDataExt = {16'b0, ReadData[15:0]};                  // LHU
        default: ReadDataExt = ReadData;
    endcase
end

// JALR detection
// JALR: Opcode 7'b1100111
wire JALR;
assign JALR = (Instr[6:0] == 7'b1100111);

// PC target selection
// For JALR, the target is the ALU result (rs1 + imm)
// For other branches/JAL, the target is PC + ImmExt
assign PCTarget = JALR ? ALUResult : (PC + ImmExt);

// next PC logic
reset_ff #(32) pcreg(clk, reset, PCNext, PC);
adder          pcadd4(PC, 32'd4, PCPlus4);
mux2 #(32)     pcmux(PCPlus4, PCTarget, PCSrc, PCNext);

// register file logic
reg_file       rf (clk, RegWrite, Instr[19:15], Instr[24:20], Instr[11:7], Result, SrcA, WriteData);
imm_extend     ext (Instr[31:0], ImmSrc, ImmExt);

// ALU logic
mux2 #(32)     srcbmux(WriteData, ImmExt, ALUSrc, SrcB);
alu            alu (SrcA, SrcB, ALUControl, ALUResult, Zero);

// Select between PCTarget (AUIPC) and ImmExt (LUI)
mux2 #(32)     uppermux(PCTarget, ImmExt, Instr[5], UpperImm);

// Result selection
mux4 #(32)     resultmux(ALUResult, ReadDataExt, PCPlus4, UpperImm, ResultSrc, Result);

// memory interface
assign Mem_WrAddr = ALUResult;
assign Mem_WrData = WriteData;

// branch logic support
assign ALUResult0 = ALUResult[0];

endmodule
