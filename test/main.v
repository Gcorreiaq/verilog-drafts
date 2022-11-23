`timescale 1ns / 1ns
`include "modules.v"


module main;

reg [31:0]a;
reg [4:0]r;
wire [31:0]y;

ror32 uuf(a,r,y);

initial begin
    $dumpfile("main.vcd");
    $dumpvars(0, main);
    a = 'b11110100101;
    r = 1;
    #20;
end
endmodule
