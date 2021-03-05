module stage_fetch(input logic clk,
                  input logic reset,
						input logic [31:0] pcbranch,
						input logic pcsrc,
						output logic [31:0] instr,
                  output logic [31:0] pcplus4);
						
	 logic [31:0] pcnext;
	 logic [31:0] pc, pcplus4_IF;
	 
    mux2 # (32) m2(.in1(pcplus4_IF), 
	                .in2(pcbranch), 
						 .c(pcsrc),
						 .out(pcnext));
	 
    flopper # (32) next_pc (.clk(clk), 
	                         .reset(reset), 
								    .d(pcnext), 
									 .q(pc)); 
	  
    adder   pcadder (.a(pc), 
	                  .b(32'b100), 
						   .sum(pcplus4_IF));
							
	 assign pcplus4 = pcplus4_IF;
	 
	 instr_memory imem (.addr(pc),
	                    .instr(instr));

endmodule 