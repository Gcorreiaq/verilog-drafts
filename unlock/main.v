`timescale 1ns / 1ns
`include "unlock.v"

module main;

reg [1:0]a;
reg clk;
reg reset;
wire unlock0;
reg [7:0]i;

reg [32:0]c;

unlock uuf(a, clk, reset, unlock0);

always #5 clk = ~clk;

initial begin
    $dumpfile("main.vcd");
    $dumpvars(0, main);

    clk = 0;
    a = 0;
    reset = 1;
    #10;

    reset = 0;
    #10;

    #10 a = 2'b11;
    #10 a = 2'b01;
    
    #20;
$finish;
end
endmodule
