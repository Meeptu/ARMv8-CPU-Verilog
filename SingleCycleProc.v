module singlecycle(
		   input resetl,
		   input [63:0] startpc,
		   output reg [63:0] currentpc,
		   output [63:0] MemtoRegOut,
		   input CLK
		   );

   // Next PC connections
   wire [63:0] nextpc;       // The next PC, to be updated on clock cycle

   // Instruction Memory connections
   wire [31:0] instruction;  // The current instruction

   // Parts of instruction
   wire [4:0] rd;            // The destination register
   wire [4:0] rm;            // Operand 1
   wire [4:0] rn;            // Operand 2
   wire [10:0] opcode;

   // Control signal wires
   wire reg2loc;
   wire alusrc;
   wire mem2reg;
   wire regwrite;
   wire memread;
   wire memwrite;
   wire branch;
   wire uncond_branch;
   wire [3:0] aluctrl;
   wire [2:0] signop;
   wire [5:0] sh_amt;

   // Register file connections
   wire [63:0] regoutA;     // Output A
   wire [63:0] regoutB;     // Output B

   // ALU connections
   wire [63:0] aluout;
   wire zero;
   

   // Sign Extender connections
   wire [63:0] extimm;

   // PC update logic
   always @(negedge CLK)
     begin
        if (resetl)
          currentpc <= #3 nextpc;
        else
          currentpc <= #3 startpc;
     end

   // Break down instruction
   assign rd = instruction[4:0];
   assign rm = instruction[9:5];
   assign rn = reg2loc ? instruction[4:0] : instruction[20:16];
   assign opcode = instruction[31:21];

   InstructionMemory imem(
			  .Data(instruction),
			  .Address(currentpc)
			  );

   control control(
		   .reg2loc(reg2loc),
		   .alusrc(alusrc),
		   .mem2reg(mem2reg),
		   .regwrite(regwrite),
		   .memread(memread),
		   .memwrite(memwrite),
		   .branch(branch),
		   .uncond_branch(uncond_branch),
		   .aluop(aluctrl),
		   .signop(signop),
		   .mov_sh(sh_amt[1:0]),
		   .opcode(opcode)
		   );

	wire [63:0] read_register_1, read_register_2;
	wire [63:0] alubusb = alusrc ? extimm : read_register_2;
	wire do_branch;
	wire [63:0] branch_add;
	
	
	//Connect ALU
	ALU alu(.BusW(aluout), .BusA(read_register_1), .BusB(alubusb), .ALUCtrl(aluctrl), .Zero(zero));
	
	//Connect DataMemory
	wire [63:0] MemoryAddress, ReadData;
	DataMemory datamem(ReadData, aluout, read_register_2, memread, memwrite, CLK);
	
	//Connect SignExtender
	SignExtender signext(extimm, instruction[25:0], signop);
	
	//Connect RegisterFile
	assign MemtoRegOut = ((mem2reg ? ReadData : aluout) << (sh_amt << 4));
	RegisterFile registers(.RA(rm), .RB(rn), .RW(rd), .BusA(read_register_1), .BusB(read_register_2), .BusW(MemtoRegOut), .RegWr(regwrite), .Clk(CLK));
	
	
	//Branch Instructions
	assign branch_add = (extimm << 2) + currentpc;
	
	assign do_branch = uncond_branch ? 1 : (branch & zero);

	assign nextpc = do_branch ? branch_add : (currentpc + 4);
	
	



endmodule

