module fadder (input a, input b, input cin, output cout, output s);
   
   assign s = a ^ b ^ cin;
   assign cout = (a & b) | (a & cin) | (b & cin);

endmodule

module fadder_N #(parameter N=32) (input [N-1:0]a, input [N-1:0]b, output [N-1:0]s);

    wire [N-1:0]cout;

    genvar i;

    fadder fa0 (a[0], b[0], 1'b0, cout[0], s[0]);

    generate
        for (i = 1;i < N;i = i + 1) begin
            fadder fa (a[i], b[i], cout[i-1], cout[i], s[i]);
        end
    endgenerate
endmodule

module adder_la4_module (input [3:0]a, input [3:0]b, input cin, output cout, output [3:0]s);

    wire [3:0]c0;
    wire [3:0]g;
    wire [3:0]p;
    wire [3:0]cout0;

    assign g = a & b;
    assign p = a | b;
    assign c0 = {g[2] | (p[2] & c0[2]), g[1] | (p[1] & c0[1]), g[0] | (p[0] & c0[0]), cin};
    assign cout = g[3] | (p[3] & c0[3]);

    genvar i;
    generate
        for (i = 0;i < 4;i = i + 1) begin
            fadder fa (a[i], b[i], c0[i], cout0[i], s[i]);
        end
    endgenerate

endmodule

module adder_la4 #(parameter N=32) (input [N-1:0]a, input [N-1:0]b, input cin, output cout, output [N-1:0]s);

    wire cout0[(N/4):0];
    assign cout0[0] = cin;

    genvar i;
    generate
        for (i = 0;i <= (N/4) - 1;i = i + 1) begin
            adder_la4_module a0 (a[(4*i)+3:i*4], b[(4*i)+3:i*4], cout0[i], cout0[i+1], s[(4*i)+3:i*4]);
        end
    endgenerate

    assign cout = cout0[(N/4)];

endmodule

module subtractor #(parameter N=32) (input [N-1:0]a, input [N-1:0]b, output [N-1:0]s);

    wire cout;
    adder_la4 #(.N(N)) a0 (a, ~b, 1'b1, cout, s);

endmodule
