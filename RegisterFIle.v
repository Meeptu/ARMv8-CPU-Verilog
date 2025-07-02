`timescale 1ns / 1ps

/*
 * Module: RegisterFile
 *
 * Implements the 32 registers used by an ARMv8 CPU, including the 0 register 
 * 
 */

module RegisterFile(BusA, BusB, BusW, RA, RB, RW, RegWr, Clk);
    output [63:0] BusA;
    output [63:0] BusB;
    input [63:0] BusW;
    input [4:0] RA;
    input [4:0] RB;
    input [4:0] RW;
    input RegWr;
    input Clk;
    reg [63:0] registers [31:0];
    
    
    initial
        begin
        registers[31] = 0;
        end
    
    assign #2 BusA = (RA != 5'd31 ? registers[RA] : 0);
    assign #2 BusB = (RB != 5'd31 ? registers[RB] : 0);
    
    always @ (negedge Clk) begin
        if(RegWr)
            if(RW != 5'd31) // Need to drop writes to the 0 register
                registers[RW] <= #3 BusW;
    end
endmodule
