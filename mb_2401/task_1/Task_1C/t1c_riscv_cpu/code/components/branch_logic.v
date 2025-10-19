// branch_logic.v - handles all 6 branch types

module branch_logic (
    input [2:0]  funct3,
    input        Zero,
    input        ALUResult0,
    input        Branch,
    output reg   PCSrc
);

always @(*) begin
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
