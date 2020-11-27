//修改成以字节为单位
module instr_mem(
    input [31:0]addr,
    output [31:0]instr
);
    wire[9:0] paddr;
    assign paddr=addr[9:0];

    reg [31:0]instr_memory[1023:0];

    initial begin
        $readmemh("",instr_memory);
    end
    assign instr=instr_memory[paddr];

endmodule