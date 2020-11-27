module Ex(
    //from id controller
    input EXOP,
    input ALUSRC,
    input [3:0]ALUOP,
    input REGDST,
    input MEMWR,
    input BRANCH,
    input BRANCHNE,
    input JRETURN,
    input JUMP,
    input JCALL,
    input MEM2REG,
    input REGWR,
    //from ID/Ex reg
    input [31:0]next_pc_id,
    input [31:0]bushA,  
    input [31:0]bushB,
    input [15:0]imm,
    input [4:0]rt,
    input [4:0]rd,
    //output controller
    output reg MEMWR_Ex,
    output reg BRANCH_Ex,
    output reg BRANCHNE_Ex,
    output reg JRETURN_Ex,
    output reg JUMP_Ex,
    output reg JCALL_Ex,
    output reg MEM2REG_Ex,
    output reg REGWR_Ex,
    //output Ex/MeM data
    output reg zero,
    output reg overflow,
    output reg [31:0]ALUout,
    output reg [31:0]tran_addr,
    output reg [4:0]regwr,
    output reg [31:0]reg_data  //寄存器内容传递
);
// ext__imm
reg [31:0]ext_imm;
ext_sign ext(
    .EXOP(EXOP),
    .imm(imm),
    .ext_imm(ext_imm),
);
//deal the jmp section
wire [31:0]t_addr;
assign t_addr={ext_imm[31:2],2'b00}+next_pc_id;

//deal the input of the alu
reg [31:0]inA;
reg [31:0]inB;

always @(posedge clk) begin
    tran_addr<=t_addr;
    overflow<=ov;
    ALUout<=aluout;
    zero<=z;
    reg_data<=bushB;
    //alu input 
    if(ALUSRC==1)begin
        inA<=bushA;
        inB<=ext_imm;
    end
    else begin
        inA<=bushA;
        inB<=bushB;
    end
    // chose the reg to write 
    if(REGDST==1) regwr<=rd;
    else regwr<=rt;
    //send the controller
    MEMWR_Ex<=MEMWR;
    BRANCH_Ex<=BRANCH;
    BRANCHNE_Ex<=BRANCHNE;
    JRETURN_Ex<=JRETURN;
    JUMP_Ex<=JUMP;
    JCALL_Ex<=JCALL;
    MEM2REG_Ex<=MEM2REG;
    REGWR_Ex<=REGWR;
end
//ALU out
wire [31:0] aluout;
output z;
output ov;
alu alu_cal(
  .ALUOP(ALUOP),
  .inA(inA),
  .inB(inB),
  .aluout(aluout),
  .zero(z),
  .overflow(ov)
);


endmodule
