`include "../basic.v"

module unlock(input [1:0]a, input clk, input reset, output unlock);

    wire [1:0]next_state;
    wire [1:0]current_state;

    assign next_state[1] = current_state[0] & ~a[1] & a[0];
    assign next_state[0] = ~current_state[1] & ~current_state[0] & a[1] & a[0];

    flip_flop s1 (next_state[1], clk, reset, current_state[1]);
    flip_flop s0 (next_state[0], clk, reset, current_state[0]);

    assign unlock = current_state[1];

endmodule
