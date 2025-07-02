`timescale 1ns / 1ps

/*
 * Module: SingleCycleControl
 *
 * Reads the opcode of an instruction and handles the control signals accordingly
 * 
 */

`define OPCODE_ANDREG 11'bz0001010zzz
`define OPCODE_ORRREG 11'bz0101010zzz
`define OPCODE_ADDREG 11'bz0z01011zzz
`define OPCODE_SUBREG 11'bz1z01011zzz

`define OPCODE_ADDIMM 11'bz0z10001zzz
`define OPCODE_SUBIMM 11'bz1z10001zzz

`define OPCODE_MOVZ   11'b110100101zz

`define OPCODE_B      11'bz00101zzzzz
`define OPCODE_CBZ    11'bz011010zzzz

`define OPCODE_LDUR   11'bzz111000010
`define OPCODE_STUR   11'bzz111000000

module control(
	       output reg 	reg2loc,
	       output reg 	alusrc,
	       output reg 	mem2reg,
	       output reg 	regwrite,
	       output reg 	memread,
	       output reg 	memwrite,
	       output reg 	branch,
	       output reg 	uncond_branch,
	       output reg [3:0] aluop,
	       output reg [2:0] signop,
	       output reg [1:0] mov_sh,
	       input [10:0] 	opcode
	       );

   always @(*)
     begin
	casez (opcode)
	
		  OPCODE_LDUR: //LDUR
		  begin
			reg2loc       = 1'bx;
			uncond_branch = 1'b0;
			branch        = 1'b0;
			memread       = 1'b1;
			mem2reg       = 1'b1;
			memwrite      = 1'b0;
            alusrc        = 1'b1;
            regwrite      = 1'b1;
            aluop         = 4'b0010;
            signop        = 3'b001;
            mov_sh        = 2'b00;
		  end

		  OPCODE_STUR: //STUR
		  begin
			reg2loc       = 1'b1;
			uncond_branch = 1'b0;
			branch        = 1'b0;
			memread       = 1'b0;
			mem2reg       = 1'b0;
			memwrite      = 1'b1;
            alusrc        = 1'b1;
            regwrite      = 1'b0;
            aluop         = 4'b0010;
            signop        = 3'b001;
            mov_sh        = 2'b00;
		  end

		  
		  OPCODE_ADDREG: //ADD
			begin
				reg2loc       = 1'b0;
				uncond_branch = 1'b0;
				branch        = 1'b0;
				memread       = 1'b0;
				mem2reg       = 1'b0;
				memwrite      = 1'b0;
                alusrc        = 1'b0;
                regwrite      = 1'b1;
                aluop         = 4'b0010;
                signop        = 3'bxxx;
                mov_sh        = 2'b00;
			end
			
			OPCODE_SUBREG: //Sub
			begin
				reg2loc       = 1'b0;
				uncond_branch = 1'b0;
				branch        = 1'b0;
				memread       = 1'b0;
				mem2reg       = 1'b0;
				memwrite      = 1'b0;
                alusrc        = 1'b0;
                regwrite      = 1'b1;
                aluop         = 4'b0110;
                signop        = 3'bxxx;
                mov_sh        = 2'b00;
			end
			
			OPCODE_ANDREG: //And
			begin
				reg2loc       = 1'b0;
				uncond_branch = 1'b0;
				branch        = 1'b0;
				memread       = 1'b0;
				mem2reg       = 1'b0;
				memwrite      = 1'b0;
                alusrc        = 1'b0;
                regwrite      = 1'b1;
                aluop         = 4'b0000;
                signop        = 3'bxxx;
                mov_sh        = 2'b00;
			end
			
			OPCODE_ORRREG: //ORR
			begin
				reg2loc       = 1'b0;
				uncond_branch = 1'b0;
				branch        = 1'b0;
				memread       = 1'b0;
				mem2reg       = 1'b0;
				memwrite      = 1'b0;
                alusrc        = 1'b0;
                regwrite      = 1'b1;
                aluop         = 4'b0001;
                signop        = 3'bxxx;
                mov_sh        = 2'b00;
			end
			
			OPCODE_CBZ: //CBZ
			begin
				reg2loc       = 1'b1;
				uncond_branch = 1'b0;
				branch        = 1'b1;
				memread       = 1'b0;
				mem2reg       = 1'b0;
				memwrite      = 1'b0;
                alusrc        = 1'b0;
                regwrite      = 1'b0;
                aluop         = 4'b0111;
                signop        = 3'b011;
                mov_sh        = 2'b00;
			end
			
			OPCODE_B: //B
			begin
				reg2loc       = 1'bx;
				uncond_branch = 1'b1;
				branch        = 1'bx;
				memread       = 1'b0;
				mem2reg       = 1'b0;
				memwrite      = 1'b0;
                alusrc        = 1'bx;
                regwrite      = 1'b0;
                aluop         = 4'b0111;
                signop        = 3'b010;
                mov_sh        = 2'b00;
			end
			
			OPCODE_MOVZ: //MOVZ
			begin
				reg2loc       = 1'bx;
				uncond_branch = 1'b0;
				branch        = 1'b0;
				memread       = 1'b0;
				mem2reg       = 1'b0;
				memwrite      = 1'b0;
                alusrc        = 1'b1;
                regwrite      = 1'b1;
                aluop         = 4'b0111;
                signop        = 3'b100;
                mov_sh        = opcode[1:0];
			end


          default:
            begin
               reg2loc       = 1'bx;
               alusrc        = 1'bx;
               mem2reg       = 1'b0;
               regwrite      = 1'b0;
               memread       = 1'b0;
               memwrite      = 1'b0;
               branch        = 1'b0;
               uncond_branch = 1'b0;
               aluop         = 4'b0111;
               signop        = 3'bxxx;
               mov_sh        = 2'b00;
            end
	endcase
     end

endmodule

