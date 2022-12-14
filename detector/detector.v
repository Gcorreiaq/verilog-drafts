`include "../basic.v"

module detect(input a, input clk, input rst, output y);

    wire [1:0]s;
    wire [1:0]s_;

    assign s_[0] = (a & ~s[0]) | (a & ~s[1]);
    assign s_[1] = (~a & s[0]) | (s[1] & ~s[0] & a);

    flip_flop f1 (s_[1], clk, rst, s[1]);
    flip_flop f0 (s_[0], clk, rst, s[0]);

    assign y = s[1] & s[0] & a;

endmodule
