// =============================================================================
// Team ID    : 2401
// Theme      : MazeSolver Bot (MB)
// Authors    : Dibyendu Maity (not.dibyendu@gmail.com) and teams
// Filename   : alu.v
// License    : MIT License (See LICENSE file in project root)
// =============================================================================
//
// Module Name : alu
//
// Description : Parameterized N-bit Arithmetic Logic Unit (ALU).
//               Supports ADD, SUB, AND, OR, XOR, SLT, SLTU, SLL, SRL, SRA
//               selected by a 4-bit alu_ctrl input.
//
// Dependencies: None
// Target EDA  : Iverilog, GTKWave, Intel Quartus Prime, ModelSim
// Target HW   : Simulation / FPGA (Cyclone IV EP4CE22F17C6)
//
// Inputs      :
//   - a[WIDTH-1:0]  : First operand
//   - b[WIDTH-1:0]  : Second operand
//   - alu_ctrl[3:0] : ALU operation select
//
// Outputs     :
//   - alu_out[WIDTH-1:0] : ALU result
//   - zero               : High when alu_out == 0
// =============================================================================

module alu #(parameter WIDTH = 32 /* WIDTH: Sets the bit-width of the ALU operands and output*/) (
    input       [WIDTH-1:0] a, b,       
    input       [3:0] alu_ctrl,         
    output reg  [WIDTH-1:0] alu_out,    
    output      zero                    
);

// a: First input operand for the ALU operation
// b: Second input operand for the ALU operation
// alu_ctrl: 4-bit control signal selecting the ALU operation
// alu_out: The result of the ALU operation
// zero: Output flag, set to 1 if alu_out is zero, 0 otherwise

// ALU control encoding:
    // 0000: ADD
    // 0001: SUB
    // 0010: AND 
    // 0011: OR 
    // 0100: XOR
    // 0101: SLT (set less than, signed)
    // 0110: SLTU (set less than, unsigned)
    // 0111: SLL (shift left logical)
    // 1000: SRL (shift right logical)
    // 1001: SRA (shift right arithmetic)

always @(a, b, alu_ctrl) begin
    /*
    Purpose:
    ---
    Combinational logic that performs an arithmetic or logical operation 
    based on the alu_ctrl input and assigns the result to alu_out.
    */
    case (alu_ctrl)
        4'b0000:  alu_out = a + b;                                           // ADD
        4'b0001:  alu_out = a + ~b + 1;                                      // SUB
        4'b0010:  alu_out = a & b;                                           // AND
        4'b0011:  alu_out = a | b;                                           // OR
        4'b0100:  alu_out = a ^ b;                                           // XOR
        4'b0101:  alu_out = ($signed(a) < $signed(b)) ? 1 : 0;               // SLT (signed)
        4'b0110:  alu_out = (a < b) ? 1 : 0;                                 // SLTU (unsigned)
        4'b0111:  alu_out = a << b[4:0];                                     // SLL (shift left logical)
        4'b1000:  alu_out = a >> b[4:0];                                     // SRL (shift right logical)
        4'b1001:  alu_out = $signed(a) >>> b[4:0];                           // SRA (shift right arithmetic)
        default:  alu_out = 0;
    endcase
end

assign zero = (alu_out == 0) ? 1'b1 : 1'b0;

endmodule
