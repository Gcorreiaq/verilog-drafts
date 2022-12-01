module ram #(parameter N=8,M=32) (input [N-1:0]addr,input [M-1:0]data,input clk,input we,output [M-1:0]dout);

    reg [M-1:0] mem [2**N-1];

always @ (posedge clk) begin
    if (we) mem[addr] <= data;
end

assign dout = mem[addr];

endmodule
        
