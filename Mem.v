module Mem(
    input clk,
    //controller from Ex module
    input MEMWR_Ex,
    input BRANCH_Ex,
    input BRANCHNE_Ex,
    input JRETURN_Ex,
    input JUMP_Ex,
    input JCALL_Ex,
    input MEM2REG_Ex,
    input REGWR_Ex,
    //data from Ex module
    input zero,
    input overflow,     //这里没有用到overflow
    input [31:0]ALUout,
    input [31:0]tran_addr,
    input [4:0]regwr,
    input [31:0]reg_data,
    // mem 
 
    output reg [31:0]rdaddr, //读取地址
    output reg wme,//写内存使能
    output reg [31:0]maddr,//写地址
    output reg [31:0]wdata, //写数据

    //controller out
    output reg MEM2REG_M,
    output reg REGWR_M,
    output reg [4:0]reg2wr,
    output reg [31:0]aluout,

    output reg JUMPEN,
    output reg [31:0]jump_pc

    
);
always @(posedge clk) begin
    if(MEMWR_Ex==1)begin
        wme<=1;
        maddr<=ALUout;
        wdata<=reg_data;
    end
    else begin
        wme<=0;
        rdaddr<=ALUout;
    end
    //分支指令的控制
     /*input BRANCH_Ex,
    input BRANCHNE_Ex,
    input JRETURN_Ex,
    input JUMP_Ex,
    input JCALL_Ex,*/
    if(BRANCH_Ex==1&&zero==1) begin   //beq
        JUMPEN<=1;
        jump_pc<=tran_addr;
    end
    else if(BRANCHNE_Ex==1&&zero==0) begin
        JUMPEN<=1;
        jump_pc<=tran_addr;
    end
    else if(JRETURN_Ex==1) begin
        JUMPEN<=1;
        jump_pc<=reg_data;
    end
    else if(JUMP_Ex==1||JCALL_Ex==1) begin
        JUMPEN<=1;
        jump_pc<=tran_addr;
    end
    else JUMPEN<=0;

    reg2wr<=regwr;
    MEM2REG_M<=MEM2REG_Ex;
    REGWR_M<=REGWR_Ex;
    aluout<=ALUout;
end
endmodule
