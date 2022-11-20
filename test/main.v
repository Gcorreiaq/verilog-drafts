`timescale 1ns / 1ns
`include "modules.v"


module main;

reg [31:0]a;
reg [31:0]b;
wire cout;
wire [31:0]s;

subtractor uuf(a, b, s);

initial begin
    $dumpfile("main.vcd");
    $dumpvars(0, main);
    a = 0;
    b = 0;
    #5;
    a = 12381;
    b = 8484;
    #5;
    #20;

end
endmodule
