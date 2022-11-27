`timescale 1ns / 1ns
`include "modules.v"


module main;

reg [31:0]a;
reg [31:0]b;
wire [31:0]y;
wire [31:0]r;

divide32 uuf(a,b,y,r);

initial begin
    $dumpfile("main.vcd");
    $dumpvars(0, main);
    a = 16;
    b = 3;
    #20;
end
endmodule
