`timescale 1ns / 1ps
/*
 * Module: NextPClogic
 *
 * Determines what instruction to go to next
 * 
 */

module NextPClogic(NextPC, CurrentPC, SignExtImm64, Branch, ALUZero, Uncondbranch); 
   input [63:0] CurrentPC, SignExtImm64; 
   input 	Branch, ALUZero, Uncondbranch; 
   output reg [63:0] NextPC; 

   always @(*)
    begin
    case({Branch, Uncondbranch})
        2'b00:
            assign NextPC = CurrentPC + 4; // Increment PC by 4 if no branch
        2'b01:
            assign NextPC = CurrentPC + (SignExtImm64 << 2); // Always branch on unconditional branch
        2'b10:
            if(ALUZero)
                assign NextPC = CurrentPC + (SignExtImm64 << 2); // Branch on conditional branch if output is 0
            else
                assign NextPC = CurrentPC + 4; // Don't branch if condition of conditional branch isn't met
        default:
            assign NextPC = CurrentPC + (SignExtImm64 << 2); 
            
    endcase
    end

endmodule
