`timescale 1ns / 1ps

/*
 * Module: SignExtender
 *
 * Implements sign extender for I-type, D-type, and branch instructions
 * 
 */

module SignExtender(BusImm, Imm26, Ctrl); 
  output [63:0] BusImm; 
  input [25:0] Imm26; 
  input [2:0] Ctrl;
  //Ctrl 00: I-Type
  //Ctrl 01: D-Type
  //Ctrl 10: B
  //Ctrl 11: CBZ

  reg extBit;
  reg [63:0] outBus;


  always @(*)
  begin
  case(Ctrl)
    3'b000:
        begin
            //I-type instructions always use unsigned immediate values, so always extend with 0s
            assign extBit = 0;
            assign outBus = {{52{extBit}}, Imm26[21:10]};
        end
    3'b001: //D-Type
        begin
            assign extBit = Imm26[20];
            assign outBus = {{55{extBit}}, Imm26[20:12]};
        end
    3'b010: //Branch
        begin
            assign extBit = Imm26[25];
            assign outBus = {{38{extBit}}, Imm26};
        end
    3'b011: //Conditional branch
        begin
            assign extBit = Imm26[23];
            assign outBus = {{46{extBit}}, Imm26[23:5]};
        end
    3'b100: //Conditional branch
        begin
            assign extBit = 0;
            assign outBus = {{49{extBit}}, Imm26[20:5]};
        end
    default: //Conditional branch
        begin
            assign extBit = Imm26[23];
            assign outBus = {{46{extBit}}, Imm26[23:5]};
        end
    endcase
   end
   
   assign BusImm = outBus;

endmodule
