// Verilog Test Bench code for AND gate
module and_gate_test_bench;

reg a, b;
wire out;

// Defining unit under test i.e And_gate
and_gate uut (.a(a), .b(b), .out(out));

// Assigning all possible states for input A and b
initial begin
    a = 0; b = 0; #100;
    a = 0; b = 1; #100;
    a = 1; b = 0; #100;
    a = 1; b = 1; #100;
end

// VCD dump for GTKWave/Iverilog simulation
initial begin
    $dumpfile("dump.vcd");
    $dumpvars(0, and_gate_test_bench);
end

// Stop simulation after all test vectors complete
// Safe on all simulators: ModelSim, Quartus, Iverilog
initial begin
    #1000;
    $finish;
end

endmodule
