module ID(
    input clk,
    input we,
    input [4:0]rw,
    input [31:0]din,   //wirte back
    input [31:0]next_pc,
    input [31:0]instr,
	 input [4:0]regaddr,
	 output [31:0]regdata,
    //controller
    output reg EXOP,
    output reg ALUSRC,
    output reg [3:0]ALUOP,
    output reg REGDST,
    output reg MEMWR,
    output reg BRANCH,
    output reg BRANCHNE,
    output reg JRETURN,
    output reg JUMP,
    output reg JCALL,
    output reg MEM2REG,
    output reg REGWR,
    //ID/Ex reg
    output reg [31:0]next_pc_id,
    output reg [31:0]bushA,  //左操作数 rt 右操作数 rs
    output reg [31:0]bushB,
    output reg [15:0]imm,
    output reg [4:0]rt,
    output reg [4:0]rd,
	 output reg [4:0]rs,
	 
	 output reg REGWR_M_ID,
	 output reg [4:0]reg_M_ID,
	 output reg [31:0]regdata_M_ID,
	 
	 input JUMPEN //上上上条指令是否为跳转指令
);

//decode
wire [5:0]op;
wire [4:0]rsreg;
wire [4:0]rtreg;
wire [4:0]rdreg;
wire [5:0]func;
wire [15:0]imm_16;

// read  regs
wire [31:0]rsdata;
wire [31:0]rtdata;


assign op=instr[31:26];
assign rsreg=instr[25:21];
assign rtreg=instr[20:16];
assign rdreg=instr[15:11];
assign func=instr[5:0];
assign imm_16=instr[15:0];
/*  EXOP : 扩展器操作  1:符号扩展  0:零扩展
        ALUSRC: ALU B口来源 1:扩展器  0: busB
        ALUOP:  ALU辅助控制码 :4
        REGDST: 目的寄存器选择  1: rd  0: rt
        RTYPE: 是否为R类型
        MEMWR: 数据存储器的写信号 1:op=sw 0:else
        BRANCH: 是否为分支指令 
        BRANCHNE: 是否为bne
        MEM2REG： 寄存器写入源 1:数据存储器  0 : ALUout
        REGWR: 是否写入寄存器
        JRETURN:是否为返回指令
        JUMP  j跳转
        JCALL jal 跳转
        */
always @(posedge clk) begin
	REGWR_M_ID<=we;
	reg_M_ID<=rw;
	regdata_M_ID<=din;

    next_pc_id<=next_pc;
    rd<=rdreg;
	 rs<=rsreg;
    imm<=imm_16;
	 bushA<=rsdata;
	 bushB<=rtdata;
    if(op==6'b000000) begin  //R指令
        rt<=rtreg;
        MEMWR<=0;
        BRANCH<=0;
        BRANCHNE<=0;
        MEM2REG<=0;
        JUMP<=0;
        JCALL<=0;
		  if(func==0)  begin             //nop
			REGWR<=0;
			JRETURN<=0;
		  end
        else if(func==6'b001011) begin    //jr指令
            JRETURN<=1;
				 REGWR<=0;
        end
        else if(func[4]==1) begin                 //无符号指令
            EXOP<=1'bx;
            ALUSRC<=0;
            ALUOP<={1'b1,func[2:0]};
            REGDST<=1;
				if(!JUMPEN) REGWR<=1; else REGWR<=0;
        end
        else begin
            EXOP<=1'bx;
            ALUSRC<=0;
            ALUOP<=func[3:0];
            REGDST<=1;
			if(!JUMPEN) REGWR<=1; else REGWR<=0;
        end
    end
    else begin  //j and i type 
        JRETURN<=0;
        if(op[5]==1'b0) begin  // i type

            rt<=rtreg;

         
            JUMP<=0;
            JCALL<=0;
            if(op[4]==1'b1)    // zero extend
                EXOP<=0;
            else EXOP<=1;
            case(op)
            6'b001110: begin        //lw 
                ALUOP<=4'b1001;   //calculate the mem
					 ALUSRC<=1;
                REGDST<=0;
                BRANCH<=0;
                BRANCHNE<=0;
                MEMWR<=0;
                MEM2REG<=1;
               if(!JUMPEN) REGWR<=1; else REGWR<=0;
            end
            6'b001111: begin    //sw
					ALUSRC<=1;
                REGDST<=1'bx;
                ALUOP<=4'b1001;
                BRANCH<=0;
                BRANCHNE<=0;
                if(!JUMPEN) MEMWR<=1; else MEMWR<=0;
                MEM2REG<=1'bx;
                REGWR<=0;
            end
            6'b001000: begin    //beq
					ALUSRC<=0;
                REGDST<=1'bx;
                ALUOP<=4'b1010;
                BRANCH<=1;
                BRANCHNE<=0;
                MEMWR<=0;
                MEM2REG<=1'bx;
                REGWR<=0;
            end
            6'b001001: begin   //bne
					ALUSRC<=0;
                REGDST<=1'bx;
                ALUOP<=4'b1010;
                BRANCH<=0;
                BRANCHNE<=1;
                MEMWR<=0;
                MEM2REG<=1'bx;
                REGWR<=0;
            end
            default:begin     //i type 运算逻辑指令
					ALUSRC<=1;
                if(op[4]==1'b1) ALUOP<={1'b1,op[2:0]};
                else ALUOP<=op[3:0];
                REGDST<=0;
                BRANCH<=0;
                BRANCHNE<=0;
                MEMWR<=0;
                MEM2REG<=0;
                if(!JUMPEN) REGWR<=1; else REGWR<=0;
            end
            endcase
        end
        else begin            
				ALUSRC<=0;
            rt<=5'b11111;    // $31($ra) 寄存器   
            if(op==6'b100000)begin   //j 
                JUMP<=1;
                JCALL<=0;
                BRANCH<=0;
                BRANCHNE<=0;
                REGWR<=0;
            end
            else if(op==6'b100001)begin   //jal
					ALUOP<=0;
                JUMP<=0;
                JCALL<=1;
                BRANCH<=0;
                BRANCHNE<=0;
                if(!JUMPEN) REGWR<=1; else REGWR<=0;
					 REGDST<=0;
					 MEM2REG<=0;
					 MEMWR<=0;
            end
            //no exception  
        end
    end
    
end


reg_mem regrd_wr(
    .clk(clk),
    .raaddr(rsreg), 
    .rbaddr(rtreg),
    .we(we),   
    .din(din), 
    .rwaddr(rw),  
    .radata(rsdata),
    .rbdata(rtdata),
	 .regaddr(regaddr),
	 .regdata(regdata)
);

endmodule
