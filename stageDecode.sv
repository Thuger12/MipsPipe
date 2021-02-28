module StageDecode (input logic clk, 
                    input logic reset,
                    input logic [31:0] instr,
                    // From writeback stage
                    input logic REGWRITE_WB,
                    input logic [31:0] result_WB,
                    input logic [4:0] writereg_WB,
                    
						  output logic [31:0] rt,
						  output logic [31:0] rd,
                    output logic [31:0] reg1, 
						  output logic [31:0] reg2,
                    output logic [31:0] signimm);

	regfile      regfile(.clk(clk), 
	                     .REGWRITE_WB(REGWRITE_WB), 
								.ra1(instr[25:21]), 
						      .ra2(instr[20:16]), 
								.ra3(writereg_WB),
						      .wd3(result_WB), 
								.rd1(reg1), 
								.rd2(reg2));

    signextend  signext(.a(instr[15:0]), 
	                     .y(signimm));
		
	 assign rt = instr[20:16];
	 assign rd = instr[15:11];
endmodule 