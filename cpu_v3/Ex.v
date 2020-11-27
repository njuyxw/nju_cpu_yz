module Ex(
    //from id controller
	 input clk,
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
	 input [4:0]rs,
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
    output reg [31:0]reg_data,  //寄存器内容传递
	 
	 input [4:0]dest_reg_Mem,
	 input [31:0]dest_regdata_Mem,
	 input REGWR_Mem,
	 input [4:0]dest_reg_W,
	 input [31:0]dest_regdata_W,
	 input REGWR_W,
	 
	 input JUMPEN
	 
);
// ext__imm
wire [31:0]ext_imm;
ext_sign ext(
    .EXOP(EXOP),
    .imm(imm),
    .ext_imm(ext_imm),
);
//deal the jmp section
wire [31:0]t_addr;
assign t_addr={ext_imm[29:0],2'b00}+next_pc_id;

//deal the input of the alu
reg [31:0]inA;
reg [31:0]inB;

always @(*) begin
	if(ALUSRC==1)begin
		if(regwr==rs&&REGWR_Ex==1)
			inA=ALUout;
		else if(dest_reg_Mem==rs&&REGWR_Mem==1)
			inA=dest_regdata_Mem;
		else if(dest_reg_W==rs&&REGWR_W==1)
			inA=dest_regdata_W;
		else inA=bushA;
		
      inB=ext_imm;
    end
    else begin
       if(regwr==rs&&REGWR_Ex==1)
			inA=ALUout;
		else if(dest_reg_Mem==rs&&REGWR_Mem==1)
			inA=dest_regdata_Mem;
		else if(dest_reg_W==rs&&REGWR_W==1)
			inA=dest_regdata_W;
		else inA=bushA;
      if(regwr==rt&&REGWR_Ex==1)
			inB=ALUout;
		else if(dest_reg_Mem==rt&&REGWR_Mem==1)
			inB=dest_regdata_Mem;
		else if(dest_reg_W==rt&&REGWR_W==1)
			inB=dest_regdata_W;
		else inB=bushB;
    end
end
always @(posedge clk) begin
    tran_addr<=t_addr;
    overflow<=ov;
	 if(JCALL)
		ALUout<=next_pc_id;
	 else
		ALUout<=aluout;
    zero<=z;
    if(JRETURN)
        reg_data<=bushA;
    else   reg_data<=bushB;
    //alu input 
    // chose the reg to write 
    if(REGDST==1) regwr<=rd;
    else regwr<=rt;
    //send the controller
	 if(!JUMPEN) 
		MEMWR_Ex<=MEMWR;
	else MEMWR_Ex<=0;
    BRANCH_Ex<=BRANCH;
    BRANCHNE_Ex<=BRANCHNE;
    JRETURN_Ex<=JRETURN;
    JUMP_Ex<=JUMP;
    JCALL_Ex<=JCALL;
    MEM2REG_Ex<=MEM2REG;
	 if(!JUMPEN)
		REGWR_Ex<=REGWR;
	else REGWR_Ex<=0;
end
//ALU out
wire [31:0] aluout;
wire z;
wire ov;
alu alu_cal(
  .ALUOP(ALUOP),
  .inA(inA),
  .inB(inB),
  .aluout(aluout),
  .zero(z),
  .overflow(ov)
);


endmodule
