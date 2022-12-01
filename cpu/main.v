`timescale 1ns / 1ns
`include "modules.v"


module main;

reg [2**8:0]addr;
reg [31:0]data;
reg clk;
reg we;
wire [31:0]dout;

ram uuf(addr,data,clk,we,dout);

always #10 clk = ~clk;

initial begin
    $dumpfile("main.vcd");
    $dumpvars(0, main);

    clk = 1;
    
    we = 1;

    for (integer i = 0;i < 2**8;i = i + 1) begin
        repeat (1) @ (posedge clk) begin
            addr <= i;
            we <= 1;
            data <= $random;
        end
    end

    we = 0;

    for (integer i = 0;i < 2**8;i = i + 1) begin
        repeat (1) @ (posedge clk) begin
            addr <= i;
            $display("%H | %h\n",addr,dout);
        end
    end
    #20;
    $finish;
end
endmodule
