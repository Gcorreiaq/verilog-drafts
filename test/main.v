`timescale 1ns / 1ns
`include "modules.v"


module main;

reg [31:0]a;
reg [31:0]b;
wire [63:0]y;


multiply32 uuf(a,b,y);

initial begin
    $dumpfile("main.vcd");
    $dumpvars(0, main);

    a = 165555;
    b = 265555;
    #20;
    $finish;
end
endmodule
