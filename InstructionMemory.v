`timescale 1ns / 1ps

/*
 * Module: InstructionMemory
 *
 * Implements read-only instruction memory
 * 
 */
module InstructionMemory(Data, Address);
   parameter T_rd = 20;
   parameter MemSize = 40;
   
   output [31:0] Data;
   input [63:0]  Address;
   reg [31:0] 	 Data;
   
   
   always @ (Address) begin

      case(Address)
	
	// Test 1
	// Load test values from memory into registers
	63'h000: Data = 32'hF84003E9; // LDUR X9, [XZR, 0x0]
	63'h004: Data = 32'hF84083EA; // LDUR X10, [XZR, 0x8]
	63'h008: Data = 32'hF84103EB; // LDUR X11, [XZR, 0x10]
	63'h00c: Data = 32'hF84183EC; // LDUR X12, [XZR, 0x18]
	63'h010: Data = 32'hF84203ED; // LDUR X13, [XZR, 0x20]
	
	// Test ORR and AND instructions on the constant held in X12
	63'h014: Data = 32'hAA0B014A; // ORR X10, X10, X11
	63'h018: Data = 32'h8A0A018C; // AND X12, X12, X10
	
	
	63'h01c: Data = 32'hB400008C; // Conditional branch to end of test 1 if X12 isn't 0
	63'h020: Data = 32'h8B0901AD; // ADD X13, X13, X9
	63'h024: Data = 32'hCB09018C; // SUB X12, X12, X9
	63'h028: Data = 32'h17FFFFFD; // Branch to 1c
	63'h02c: Data = 32'hF80203ED; // STUR X13, [XZR, 0x20]
	63'h030: Data = 32'hF84203ED;  //One last load to place stored value on memdbus for test checking.
	
	
	// Test 2
	63'h034: Data = {9'b110100101, 2'b00, {16{1'b0}}, 5'h9};
	63'h038: Data = {9'b110100101, 2'b01, 16'h0032, 5'h10};
	
	63'h03c: Data = {9'b110100101, 2'b11, {16'h1234}, 5'h9}; //MOVZ X9 [48, 0x1234]
	
	63'h040:  Data = {9'b110100101, 2'b10, {16'h5678}, 5'ha}; //MOVZ X10 [32, 0x5678]
	63'h044:  Data = 32'h8b0a0129; //ADD X9, X9, X10
	
	63'h048:  Data = {9'b110100101, 2'b01, {16'h9abc}, 5'ha}; //MOVZ X10 [32, 0x5678]
	63'h04c:  Data = 32'h8b0a0129; //ADD X9, X9, X10
	
	63'h050:  Data = {9'b110100101, 2'b00, {16'hdef0}, 5'ha}; //MOVZ X10 [00, 0x5678]
	63'h054:  Data = 32'h8b0a0129; //ADD X9, X9, X10
	
	//Test 3
	63'h058:  Data = {11'b11111000000, 9'h28, 2'h0, 5'h1F,  5'h9}; //STUR X9 0x28
	
	63'h05c:  Data = {11'b11111000010, 9'h28, 2'h0, 5'h1F, 5'ha}; //LDUR X10 0x28

	
	default: Data = 32'hXXXXXXXX;
      endcase
   end
endmodule
