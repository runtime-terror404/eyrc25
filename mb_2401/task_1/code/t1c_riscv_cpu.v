
// // t1c_riscv_cpu.v - Top Module to test riscv_cpu

// module t1c_riscv_cpu (
//     input         clk, reset,
//     input         Ext_MemWrite,
//     input  [31:0] Ext_WriteData, Ext_DataAdr,
//     output        MemWrite,
//     output [31:0] WriteData, DataAdr, ReadData,
//     output [31:0] PC, Result
// );

// wire [31:0] Instr;
// wire [31:0] DataAdr_rv32, WriteData_rv32;
// wire        MemWrite_rv32;

// // instantiate processor and memories
// riscv_cpu rvcpu    (clk, reset, PC, Instr,
//                     MemWrite_rv32, DataAdr_rv32,
//                     WriteData_rv32, ReadData, Result);
// instr_mem instrmem (PC, Instr);
// data_mem  datamem  (clk, MemWrite, DataAdr, WriteData, ReadData);

// assign MemWrite  = (Ext_MemWrite && reset) ? 1 : MemWrite_rv32;
// assign WriteData = (Ext_MemWrite && reset) ? Ext_WriteData : WriteData_rv32;
// assign DataAdr   = reset ? Ext_DataAdr : DataAdr_rv32;

// endmodule

// t1c_riscv_cpu.v - Top Module to test riscv_cpu

module t1c_riscv_cpu (
    input         clk, reset,
    input         Ext_MemWrite,
    input  [31:0] Ext_WriteData, Ext_DataAdr,
    output        MemWrite,
    output [31:0] WriteData, DataAdr, ReadData,
    output [31:0] PC, Result
);

wire [31:0] Instr;
wire [31:0] DataAdr_rv32, WriteData_rv32;
wire        MemWrite_rv32;

// instantiate processor and memories
riscv_cpu rvcpu (
    .clk(clk),
    .reset(reset),
    .PC(PC),
    .Instr(Instr),
    .MemWrite(MemWrite_rv32),
    .Mem_WrAddr(DataAdr_rv32),
    .Mem_WrData(WriteData_rv32),
    .ReadData(ReadData),
    .Result(Result)
);

instr_mem instrmem (
    .instr_addr(PC),
    .instr(Instr)
);

data_mem datamem (
    .clk(clk),
    .wr_en(MemWrite),
    .wr_addr(DataAdr),
    .wr_data(WriteData),
    .rd_data_mem(ReadData)
);

assign MemWrite  = (Ext_MemWrite && reset) ? 1'b1 : MemWrite_rv32;
assign WriteData = (Ext_MemWrite && reset) ? Ext_WriteData : WriteData_rv32;
assign DataAdr   = reset ? Ext_DataAdr : DataAdr_rv32;

endmodule
