module controller(input logic CLK, RESET,
                  // Input
                  input logic [5:0] opcode, funct,
                  input logic ZERO_M,
						
                  // For execute stage
                  output logic REGWRITE_E, MEMTOREG_E, MEMWRITE_E,
                  output logic BRANCH_E, ALUSRC_E, REGDST_E,
                  output logic [2:0] ALUCONTROL_E,
						
                  // For memwrite stage
                  output logic REGWRITE_M, MEMTOREG_M, MEMWRITE_M,
                  output logic BRANCH_M, PCSRC_M,
						
                  // For write back stage
                  output logic REGWRITE_WB, MEMTOREG_WB);
						
	// Signals from control unit after decode
	logic REGWRITE_D, MEMTOREG_D, MEMWRITE_D, 
			BRANCH_D, ALUSRC_D, REGDST_D;
	logic [2:0] ALUCONTROL_D;
	
	// Signal from maindecoder to aludecoder
	logic [1:0] aluop;
	

	Maindecoder maindecoder(opcode,
						REGWRITE_D, MEMTOREG_D,
						MEMWRITE_D, BRANCH_D,
						ALUSRC_D, REGDST_D, aluop);
						
	
	Aludecoder aludecoder(funct, aluop, ALUCONTROL_D);
	
	assign PCSRC_M = ZERO_M & BRANCH_M;
	
	flopper #(9) exec(CLK, RESET,
						
							{REGWRITE_D, MEMTOREG_D,
							 MEMWRITE_D, BRANCH_D,
							 ALUSRC_D, REGDST_D,
							 ALUCONTROL_D},
						
							{REGWRITE_E, MEMTOREG_E,
							 MEMWRITE_E, BRANCH_E,
							 ALUSRC_E, REGDST_E,
							 ALUCONTROL_E});
	
	flopper #(4) memory(CLK, RESET,
	
							  {REGWRITE_E, MEMTOREG_E,
							   MEMWRITE_E, BRANCH_E},
				
							  {REGWRITE_M, MEMTOREG_M,
							   MEMWRITE_M, BRANCH_M});
	
	flopper #(2) writeback(CLK, RESET,
								  // Input
								  {REGWRITE_M, MEMTOREG_M},
								  // Output
								  {REGWRITE_WB, MEMTOREG_WB});

endmodule


module Maindecoder(input logic [5:0] opcode,
                   output logic REGWRITE_D, MEMTOREG_D,
                   output logic MEMWRITE_D, BRANCH_D,
                   output logic ALUSRC_D, REGDST_D,
                   output logic [1:0] aluop);
						 
	always_comb
		case (opcode)
		// R type depends on funct
			6'b000000: begin 
				MEMTOREG_D <= 1'b0;
				MEMWRITE_D <= 1'b0;
				REGDST_D   <= 1'b1;
				REGWRITE_D <= 1'b1;
				ALUSRC_D   <= 1'b0;
				BRANCH_D   <= 1'b0;
				aluop      <= 2'b10;
			end
			// LW
			6'b100011: begin
				MEMTOREG_D <= 1'b1;
				MEMWRITE_D <= 1'b0;
				REGDST_D   <= 1'b0;
				REGWRITE_D <= 1'b1;
				ALUSRC_D   <= 1'b1;
				BRANCH_D   <= 1'b0;
				aluop      <= 2'b0;
			end
			// SW
			6'b101011: begin
				MEMTOREG_D <= 1'b0;
				MEMWRITE_D <= 1'b1;
				REGDST_D   <= 1'b0;
				REGWRITE_D <= 1'b0;
				ALUSRC_D   <= 1'b1;
				BRANCH_D   <= 1'b0;
				aluop      <= 2'b00;
			end
			// BEQ
			6'b000100: begin
				MEMTOREG_D <= 1'b0;
				MEMWRITE_D <= 1'b0;
				REGDST_D   <= 1'b0;
				REGWRITE_D <= 1'b0;
				ALUSRC_D   <= 1'b0;
				BRANCH_D   <= 1'b1;
				aluop      <= 2'b01;
			end
			// ADDI
			6'b001000: begin
				MEMTOREG_D <= 1'b0;
				MEMWRITE_D <= 1'b0;
				REGDST_D   <= 1'b0;
				REGWRITE_D <= 1'b1;
				ALUSRC_D   <= 1'b1;
				BRANCH_D   <= 1'b0;
				aluop      <= 2'b0;
			end
			// J
			6'b000010: begin
				MEMTOREG_D <= 1'b0;
				MEMWRITE_D <= 1'b0;
				REGDST_D   <= 1'b0;
				REGWRITE_D <= 1'b1;
				ALUSRC_D   <= 1'b1;
				BRANCH_D   <= 1'b0;
				aluop      <= 2'b0;
			end
			// ILLEGAL
			default: begin
				MEMTOREG_D <= 1'b0;
				MEMWRITE_D <= 1'b0;
				REGDST_D   <= 1'b0;
				REGWRITE_D <= 1'b0;
				ALUSRC_D   <= 1'b0;
				BRANCH_D   <= 1'b0;
				aluop      <= 2'b0;
			end
		endcase	 
endmodule


module Aludecoder(input logic [5:0] funct,
						input logic [1:0] aluop,
						output logic [2:0] ALUCONTROL);
	always_comb
		case(aluop)
			2'b00: ALUCONTROL <= 3'b010; // adding
			2'b01: ALUCONTROL <= 3'b110; // subtracting for BEQ
			default: case (funct)
							6'b100000: ALUCONTROL <= 3'b010; // add 
							6'b100010: ALUCONTROL <= 3'b110; // sub
							6'b100100: ALUCONTROL <= 3'b000; // and
							6'b100101: ALUCONTROL <= 3'b001; // or
							6'b101010: ALUCONTROL <= 3'b111; // slt
							default:   ALUCONTROL <= 3'bxxx; // illegal funct
						endcase
		endcase
endmodule
