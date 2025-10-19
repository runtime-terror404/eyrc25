

// imm_extend.v - logic for sign extension
module imm_extend (
    input  [31:0]     instr,
    input  [ 1:0]     immsrc,
    output reg [31:0] immext
);

always @(*) begin
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
