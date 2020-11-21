module reg_mem(
    input clk,
    input [4:0]raaddr, 
    input [4:0]rbaddr,
    input we,   //wirte enable
    input [31:0]din, //data in
    input [4:0]rwaddr,  //write reg address
    output [31:0]radata,
    output [31:0]rbdata
);
    reg [31:0]reg_memory[31:0];  // 32 regs
    /*initial begin
        $readmemh("",reg_memory);
    end*/  
    assign radata=reg_memory[raaddr];
    assign rbdata=reg_memory[rbaddr];
    
    always @(posedge clk) begin
        if(we) begin
            reg_memory[rwaddr]<=din;
        end
    end

endmodule