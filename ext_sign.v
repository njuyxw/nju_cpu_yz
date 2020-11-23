module ext_sign(
    input EXOP,
    input [15:0]imm,
    output reg [31:0]ext_imm
);
always @(*) begin
    if(EXOP&&imm[15]==1)
         ext_imm={16'hffff,imm};
    else 
        ext_imm={16'h0000,imm};
end
endmodule