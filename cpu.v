/*
    五级流水线cpu
    该模块进行流水线组装
*/
module cpu(
    input clk,
    input [31:0]memdata,  //数据线
    output reg[31:0]rdaddr, //读地址线
    output reg[31:0]maddr, //写地址线
    output reg[31:0]wdata,  //写数据
    output reg wme
);

wire JUMPEN;
wire [31:0]jump_pc;
wire [31:0]next_pc;
wire [31:0]instr;

IF IFmd(
    .clk(clk),
    .JUMPEN(JUMPEN),
    .jump_pc(jump_pc),
    .next_pc(next_pc),
    .instr(instr)
);

wire regwe;
wire rw;
wire [31:0]regdin;

wire EXOP;
wire ALUSRC;
wire [3:0]ALUOP;
wire REGDST;
wire MEMWR;
wire BRANCH;
wire BRANCHNE;
wire JRETURN;
wire JUMP;
wire JCALL;
wire MEM2REG,;
wire REGWR;

wire [31:0]busA;
wire [31:0]busB;
wire [15:0]imm;
wire [4:0]rt;
wire [4:0]rd;
wire [31:0]next_pc_id;
ID IDmd(
    .clk(clk),
    .we(regwe),
    .rw(rw),
    .din(regdin),   //wirte back
    .next_pc(next_pc),
    .instr(instr),
    //controller
    .EXOP(EXOP),
    .ALUSRC(ALUSRC),
    .ALUOP(ALUOP),
    .REGDST(REGDST),
    .MEMWR(MEMWR),
    .BRANCH(BRANCH),
    .BRANCHNE(BRANCHNE),
    .JRETURN(JRETURN),
    .JUMP(JUMP),
    .JCALL(JCALL),
    .MEM2REG(MEM2REG),
    .REGWR(REGWR),
    //ID/Ex reg
    .next_pc_id(next_pc_id),
    .bushA(busA),  //左操作数 rt 右操作数 rs
    .bushB(busB),
    .imm(imm),
    .rt(rt),
    .rd(rd)
);
wire MEMWR_Ex;
wire BRANCH_Ex;
wire BRANCHNE_Ex;
wire JRETURN_Ex;
wire JUMP_Ex;
wire JCALL_Ex;
wire MEM2REG_Ex;
wire REGWR_Ex;
wire zero;
wire overflow;
wire [31:0]ALUout;
wire [31:0]tran_addr;
wire [4:0]regwr;
wire [31:0]reg_data; 

Ex Exmd(
    //from id controller
    .EXOP(EXOP),
    .ALUSRC(ALUSRC),
    .ALUOP(ALUOP),
    .REGDST(REGDST),
    .MEMWR(MEMWR),
    .BRANCH(BRANCHNE),
    .BRANCHNE(BRANCHNE),
    .JRETURN(JRETURN),
    .JUMP(JUMP),
    .JCALL(JCALL),
    .MEM2REG(MEM2REG),
    .REGWR(REGWR),
    //from ID/Ex reg
    .next_pc_id(next_pc_id),
    .bushA(busA),  
    .bushB(busB),
    .imm(imm),
    .rt(rt),
    .rd(rd),
    //output controller
    .MEMWR_Ex(MEMWR_Ex),
    .BRANCH_Ex(BRANCH_Ex),
    .BRANCHNE_Ex(BRANCHNE_Ex),
    .JRETURN_Ex(JRETURN_Ex),
    .JUMP_Ex(JUMP_Ex),
    .JCALL_Ex(JCALL_Ex),
    .MEM2REG_Ex(MEM2REG_Ex),
    .REGWR_Ex(REGWR_Ex),
    //output Ex/MeM data
    .zero(zero),
    .overflow(overflow),
    .ALUout(ALUout),
    .tran_addr(tran_addr),
    .regwr(regwr),
    .reg_data(reg_data)  //寄存器内容传递
);

wire MEM2REG_M;
wire REGWR_M;
wire [4:0]reg2wr;
wire aluout;

Mem Memmd(
    .MEMWR_Ex(MEMWR_Ex),
    .BRANCH_Ex(BRANCH_Ex),
    .BRANCHNE_Ex(BRANCHNE_Ex),
    .JRETURN_Ex(JRETURN_Ex),
    .JUMP_Ex(JUMP_Ex),
    .JCALL_Ex(JCALL_Ex),
    .MEM2REG_Ex(MEM2REG_Ex),
    .REGWR_Ex(REGWR_Ex),
    .zero(zero),
    .overflow(overflow),     //这里没有用到overflow
    .ALUout(ALUout),
    .tran_addr(tran_addr),
    .regwr(regwr),
    .reg_data(reg_data),
    .rdaddr(rdaddr), //读取地址
    .wme(wme),//写内存使能
    .maddr(maddr),//写地址
    .wdata(wdata), //写数据
    .MEM2REG_M(MEM2REG_M),
    .REGWR_M(REGWR_M),
    .reg2wr(reg2wr),
    .aluout(aluout),
    .JUMPEN(JUMPEN),
    .jump_pc(jump_pc)
);

Wr Wrmd(
    .clk(clk),
    .MEM2REG_M(MEM2REG_M),
    .REGWR_M(REGWR_M),
    .reg2wr(reg2wr),
    .memdata(memdata),
    .aludata(aluout),

    .rw(rw),
    .din(regdin),
    .we(regwe)
);

endmodule