module latch(input r, input s, output q, output neq_q);

    assign neq_q = ~(s | q);
    assign q = ~(r | neq_q);

endmodule

module d_latch(input d, input e, input rst, output q, output neq_q);

    wire r;
    wire s;

    assign r = e & (~d);
    assign s = e & d;

    latch l0 (r | rst,s & ~rst,q,neq_q);
    
endmodule

module flip_flop(input d, input clk, input rst, output q);

    wire neq_clk, neq_q;
    wire q0, neq_q0;
    assign neq_clk = ~clk;

    d_latch d0 (d,neq_clk,rst,q0,neq_q0);
    d_latch d1 (q0,clk,rst,q,neq_q);

endmodule
