`include "../basic.v"

module fadder (input a, input b, input cin, output cout, output s);
   
   assign s = a ^ b ^ cin;
   assign cout = (a & b) | (a & cin) | (b & cin);

endmodule

module fadder_N #(parameter N=32) (input [N-1:0]a, input [N-1:0]b, output [N-1:0]s);
/* ripple carry adder */

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
/* lookahead carry adder */

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

module comparator #(parameter N=32) (input [N-1:0]a, input [N-1:0]b, output y);

    wire [N-1:0]ab_xor = a ^ b;
    assign y = &(~ab_xor);

endmodule

module comparator_gt #(parameter N=32) (input [N-1:0]a, input [N-1:0]b, output gt);

    wire [N-1:0]sub;
    
    subtractor #(.N(N)) s0 (a,b,sub);

    assign gt = sub[N-1] ? 1'b0 : 1'b1;

endmodule

module mux2 #(parameter N=1) (input [N-1:0]a, input [N-1:0]b, input s, output [N-1:0]y);

    assign y = s ? a : b;

endmodule

module mux32 (input [31:0]a, input [4:0]r, output y);

    wire [15:0]m16;
    wire [7:0]m8;
    wire [3:0]m4;
    wire [1:0]m2;

    mux2 #(.N(16)) mux0 (a[31:16],a[15:0],r[4], m16);
    mux2 #(.N(8)) mux1 (m16[15:8],m16[7:0],r[3],m8);
    mux2 #(.N(4)) mux2 (m8[7:4],m8[3:0],r[2],m4);
    mux2 #(.N(2)) mux3 (m4[3:2],m4[1:0],r[1],m2);
    mux2 mux4 (m2[1],m2[0],r[0],y);

endmodule


module shl32 (input [31:0]a, input [4:0]r, output [31:0]y);

    wire [31:0]o;
    assign o = 'b0;

    mux32 mux (a,~r,y[31]);
    genvar i;
    generate
        for (i = 1;i < 32;i = i + 1) begin
            mux32 mux ({a[31-i:0],o[i-1:0]},~r,y[31-i]);
        end
    endgenerate

endmodule

module shr32 (input [31:0]a, input [4:0]r, output [31:0]y);

    wire [31:0]o;
    assign o = 'b0;

    mux32 mux (a,r,y[0]);
    genvar i;
    generate
        for (i = 1;i < 32;i = i + 1) begin
            mux32 mux ({a[31-i:0],o[i-1:0]},r,y[i]);
        end
    endgenerate
endmodule

module rol32 (input [31:0]a, input [4:0]r, output [31:0]y);

    mux32 mux (a,~r,y[31]);
    genvar i;
    generate
        for (i = 1;i < 32;i = i + 1) begin
            mux32 mux ({a[31-i:0],a[31:32-i]},~r,y[31-i]);
        end
    endgenerate
endmodule

module ror32 (input [31:0]a, input [4:0]r, output [31:0]y);

    wire [4:0]ro = r & 'b11110;
    mux32 mux (a,ro,y[31]);
    genvar i;
    generate
        for (i = 1;i < 32;i = i + 1) begin
            mux32 mux ({a[31-i:0],a[31:32-i]},ro,y[31-i]);
        end
    endgenerate
endmodule

module multiply32 (input [31:0]a, input [31:0]b, output [63:0]y,output [63:0]t);
/* N-bit multiplication produces 2N-bit output */

    assign y[0] = a[0] & b[0];
    wire [1024:0]cin;
    wire [1024:0]f;

    assign cin[0] = 1'b0;

    genvar i,j;
    generate
        for (i = 1;i < 32;i = i + 1) begin
            fadder fa (a[i] & b[0],a[i-1] & b[1],cin[i-1],cin[i],f[i-1]);
        end

        fadder fa (a[31] & b[1],1'b0,cin[31],cin[32],f[31]);

        for (i = 0;i < 30;i = i + 1) begin
            fadder f0 (a[0] & b[i+2],f[(i*32)+1],cin[0],cin[((i+1)*32)+1],f[(i+1)*32]);
            for (j = 0;j < 30;j = j + 1) begin
                fadder f0 (a[j+1] & b[i+2],f[(i*32)+j+2],cin[((i+1)*32)+j+1],cin[((i+1)*32)+j+2],f[((i+1)*32)+j+1]);
            end
            fadder f1 (a[31] & b[i+2],cin[(i*32)+32],cin[((i+1)*32)+31],cin[((i+1)*32)+32],f[((i+1)*32)+31]);
        end

        for (i = 1;i < 32;i = i + 1) begin
            assign y[i] = f[(i-1)*32];
        end
        for (i = 0;i < 32;i = i + 1) begin
            assign y[31+i] = f[(30*32)+i];
        end
        assign y[63] = cin[(30*32)+31];

    endgenerate

endmodule
module alu32 (input [31:0]a, input [31:0]b, input [3:0]f, input clk, output reg [31:0]y);

    wire [31:0]out0 = a & b;
    wire [31:0]out1 = a | b;
    wire [31:0]out2;
    wire out3;
    wire out4;

    subtractor s0 (a,b,out2);
    comparator comp0 (a,b,out3);
    comparator_gt comp_gt (a,b,out4);

    always @ (posedge clk) begin
        case (f)
            4'b00: y <= out0;
            4'b01: y <= out1;
            4'b10: y <= out2;
            4'b11: y <= out3;
            4'b100: y <= out4;
        endcase
    end
endmodule

module reg32 (input [31:0]d, input clk, output [31:0]q);

    genvar i;
    generate
        for (i = 0;i < 32;i = i + 1) begin
            flip_flop reg32_ff (d[i],clk,1'b0,q[i]);
        end
    endgenerate

endmodule

module cpu (input [3:0]f, input [31:0]a, input [31:0]b, input clk, output [31:0]eax);

    alu32 alu_cpu(a,b,f,clk,eax);

endmodule
