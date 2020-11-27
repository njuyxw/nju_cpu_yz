module IF(
    input clk,
    input JUMPEN,
    input [31:0]jump_pc,
    output reg [31:0]next_pc,
    output reg [31:0]instr
);
reg [31:0] pc;
wire [31:0] middle_instr;
initial begin
    pc=0;
end
always @(posedge clk) begin
    if(JUMPEN) 
        pc<=jump_pc;
    else pc<=pc+4;
    next_pc<=pc+4;
	 instr <= middle_instr;
end

instr_mem read_instr(
    pc,
    middle_instr
);

endmodule
