`timescale 1ns / 1ns
`include "detector.v"

module main;

reg a;
reg clk;
reg rst;
wire y;
integer i;

detect uuf(a, clk, rst, y);

always #5 clk = ~clk;

initial begin
    $dumpfile("main.vcd");
    $dumpvars(0, main);

    clk = 0;
    a = 0;
    
    repeat (5) @ (posedge clk) begin
    rst = 1;
    end
    
    @ (posedge clk) rst = 0;
    @ (posedge clk) a = 1;
    @ (posedge clk) a = 1;
    @ (posedge clk) a = 0;
    @ (posedge clk) a = 1;
    @ (posedge clk) a = 1;
    @ (posedge clk) a = 1;
    @ (posedge clk) a = 1;
    @ (posedge clk) a = 1;
    @ (posedge clk) a = 1;

    #50;
    $finish;
end
endmodule
