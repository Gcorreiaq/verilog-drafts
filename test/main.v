`timescale 1ns / 1ns
`include "modules.v"


module main;

reg [31:0]a;
reg [31:0]b;
wire gt;

comparator_gt uuf(a, b, gt);

initial begin
    $dumpfile("main.vcd");
    $dumpvars(0, main);
    a = 0;
    b = 0;
    #5;
    a = 12381;
    b = 8484;
    #5;
    a = 8484;
    b = 12381;
    #5;
    a = -5;
    b = -6;
    #5;
    a = -6;
    b = -5;
    #5;
    a = -6;
    b = 5;
    #5;
    a = 5;
    b = -6;
    #5;
    #20;

end
endmodule
