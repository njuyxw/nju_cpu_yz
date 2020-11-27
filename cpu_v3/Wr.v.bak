module Wr(
    input clk,
    input MEM2REG_M,
    input REGWR_M,
    input [4:0]reg2wr,
    input [31:0]memdata,
    input [31:0]aludata,

    output reg [4:0]rw,
    output reg [31:0]din,
    output reg we
);
always @(posedge clk) begin
    if(REGWR_M) begin
        we<=1;
        rw<=reg2wr;
        if(MEM2REG_M==1) din<=memdata;
        else din<=aludata;
    end
    else we<=0;
end

endmodule