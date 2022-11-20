module latch(input r, input s, output q, output neq_q);

    assign neq_q = ~(s | q);
    assign q = ~(r | neq_q);

endmodule

module d_latch(input d, input e, output q, output neq_q);

    wire r;
    wire s;

    assign r = e & (~d);
    assign s = e & d;

    latch l0 (r,s,q,neq_q);
    
endmodule

module flip_flop(input d, input clk, input reset, output q);

    wire data;
    wire neq_clk, neq_q;
    wire q0, neq_q0;
    assign neq_clk = ~clk;
    assign data = d & ~reset;

    d_latch d0 (data, neq_clk, q0, neq_q0);
    d_latch d1 (q0, clk, q, neq_q);

endmodule
