`timescale 1ns / 1ps

/*
 * Module: Arithmetic Logic Unit
 *
 * Implements ALU which performs computations on inputs 
 * accroding to control signal, ALUCtrl
 * 
 */



`define AND   4'b0000
`define OR    4'b0001
`define ADD   4'b0010
`define SUB   4'b0110
`define PassB 4'b0111


module ALU(BusW, BusA, BusB, ALUCtrl, Zero);
    
    output  [63:0] BusW; // Output Bus
    input   [63:0] BusA, BusB; // Inputs A and B
    input   [3:0] ALUCtrl; // Control signal
    output  Zero; // Ouputs 1 when BusW is 0 and outputs 0 otherwise
    
    reg     [63:0] BusW;
    
    always @(ALUCtrl or BusA or BusB) begin
        case(BusB)
            {64{1'bX}}:
                BusW = 0;
                
            default:
                case(ALUCtrl)
                    `AND: begin
                        BusW = BusA & BusB; // AND instruction
                    end
                    `OR: begin
                        BusW = BusA | BusB; // OR instruction
                    end
                    `ADD: begin
                        BusW = BusA + BusB; // ADD instruction
                    end
                    `SUB: begin
                        BusW = BusA - BusB; // Subtract instruction
                    end
                    `PassB: begin // Pass input instruction passes the second input down the pipeline
                        case(BusB)
                            {64{1'bX}}:
                                BusW = 0;
                            default:
                                BusW = BusB;
                        endcase
                    end
                    default:
                        BusW = 0;
        
                endcase
        endcase
    end
  
  assign Zero = (BusW == 0) ? 1 : 0; // Sets the zero bit of the ALU according to its output
   
      
endmodule