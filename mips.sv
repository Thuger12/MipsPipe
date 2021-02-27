/*
Control signals:
-- MEMTOREG:
				choose what to write into register(data from memory or aluresult)
-- MEMWRITE:
				enable to write data into memory block
-- BRANCH:
				for BEQ command
-- alucontrol [2:0]:
				signal for alu module
-- ALUSRC:
				choose between immediate value and register data
-- regdst:
				choose destination register
-- REGWRITE:
				enable to write into register file
-- jump:
				for j command (26bits from instr, 4 bits of prev pc)
*/ 


module mips(input logic clk, 
            input logic reset,
				input logic [31:0] instr, 	  // Instruction from memory
				input logic [31:0] readdata, // Data from memory
				
				output logic [31:0] pc,
				output logic MEMWRITE,
				output logic [31:0] aluresult,  // Memory adress where to write data
				output logic [31:0] writedata); // Data to write to memory
				
	// Signals for execute stage
	logic REGWRITE_E, MEMTOREG_E, MEMWRITE_E,
		  BRANCH_E, ALUSRC_E, REGDST_E;
	logic [2:0] ALUCONTROL_E;
	
	// Signals for memory stage
	logic REGWRITE_M, MEMTOREG_M, MEMWRITE_M,
			BRANCH_M, PCSRC_M;
	logic ZERO_M;
	assign MEMWRITE = MEMWRITE_M;
	

	// Signals for writeback stage
	logic REGWRITE_WB, MEMTOREG_WB;
			
   logic [31:0] instr_D;
						  
	controller control(.CLK(clk), .RESET(reset),
                      .opcode(instr_D[31:26]), .funct(instr_D[5:0]), 
							 .ZERO_M(ZERO_M),

                      .REGWRITE_E(REGWRITE_E), .MEMTOREG_E(MEMTOREG_E), 
							 .MEMWRITE_E(MEMWRITE_E),
                      .BRANCH_E(BRANCH_E), .ALUSRC_E(ALUSRC_E), 
							 .REGDST_E(REGDST_E), .ALUCONTROL_E(ALUCONTROL_E),
 
                      .REGWRITE_M(REGWRITE_M), .MEMTOREG_M(MEMTOREG_M), 
							 .MEMWRITE_M(MEMWRITE_M),
                      .BRANCH_M(BRANCH_M), .PCSRC_M(PCSRC_M),

                      .REGWRITE_WB(REGWRITE_WB), .MEMTOREG_WB(MEMTOREG_WB));
	 
	datapath dp(.clk(clk), .reset(reset),
               PCSRC_M,
	            ALUCONTROL_E, ALUSRC_E, REGDST_E,
					ZERO_M,
					REGWRITE_WB, MEMTOREG_WB,
					instr, readdata,
					pc,
					aluresult,
					writedata, instr_D);
endmodule 
