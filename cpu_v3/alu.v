module alu(
  input [3:0]ALUOP,
  input [31:0]inA, //inA代表rs ,inB代表rt
  input [31:0]inB,
  output reg [31:0]aluout,
  output zero,
  output reg overflow
);
    wire [31:0] add;
    wire [31:0] sub;
    assign add = inA + inB;
    assign sub = inA - inB;
    assign zero = (aluout == 0);
    always @ (*) begin
        case (ALUOP)
        // signed add
        4'b0001: begin
            aluout <= add;
            overflow <= (inA[31] == inB[31]) & (inA[31] != add[31]);
            $display("%d+%d=%d, of=%b", inA, inB, add, (inA[31] == inB[31]) & (inA[31] != add[31]));
        end

        //signed sub
        4'b0010: begin
            aluout <= sub;
            overflow <= (inA[31] != inB[31]) & (inB[31] == sub[31]);
        end

        //and
        4'b0011: begin
            aluout <= inA & inB;
            overflow <= 0 ;
        end
        //or
        4'b0100: begin
            aluout <= inA | inB;
            overflow <= 0;
        end

        //xor
        4'b0101: begin
            aluout <= inA ^ inB;
            overflow <= 0;
        end

        //nor
        4'b0110: begin
            aluout <= ~(inA | inB);
            overflow <= 0;
        end

        //slt
        4'b0111: begin
            aluout <= ($signed(inA) < $signed(inB)) ? 1 : 0;
            overflow <= 0;
        end
        

        //unsigned add addu
        4'b1001: begin
            aluout <= add;
            overflow <= 0;
        end
        //unsigned sub subu
        4'b1010: begin
            aluout <= sub;
            overflow <= 0;
        end
        //sllv
        4'b1100: begin
            aluout <= inB << inA;
            overflow <= 0;
        end
        //srlv
        4'b1101: begin
            aluout <= inB >> inA;
            overflow <= 0;
        end
        //srav
        4'b1110: begin
            aluout <= $signed(inB) >>> inA;
            overflow <= 0;
        end
        default: begin
		  // output inB so that LUI can work
            aluout <= inB;
            overflow <= 0;
        end
        endcase
    end
endmodule 
