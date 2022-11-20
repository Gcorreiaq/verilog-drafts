module glitch (input a, input b, input c, output q);

    wire n1;
    wire n2;

/* simulating glitch */

    assign #2 n1  = ~a & ~b;
    assign #1 n2  = c & b;

    assign q = n1 | n2;

endmodule
