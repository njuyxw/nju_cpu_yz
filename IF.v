module IF(
    input clk,
    input JUMPEN,
    input [31:0]jump_pc,
    output reg [31:0]next_pc,
    output reg [31:0]instr
);
reg [31:0] pc;
initial begin
    pc=0;
end
always @(posedge clk) begin
    if(JUMPEN) 
        pc<=jump_pc;
    else pc<=pc+4;
    next_pc<=pc+4;
end

instr_mem read_instr(
    .addr(pc),
    .instr(instr)
);

endmodule