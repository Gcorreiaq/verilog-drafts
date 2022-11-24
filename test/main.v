`timescale 1ns / 1ns
`include "modules.v"


module main;

reg [31:0]a;
reg [31:0]b;
wire [63:0]y;
wire [63:0]t;

multiply32 uuf(a,b,y,t);

initial begin
    $dumpfile("main.vcd");
    $dumpvars(0, main);
    a = 0;
    b = 0;
    #20;
    a = ~a;
    b = ~b;
    #20;
end
endmodule
