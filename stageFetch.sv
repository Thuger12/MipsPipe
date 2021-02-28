module StageFetch(input logic clk,
                  input logic reset,
						input logic [31:0] pcbranch,
						input logic PC_SRC,
						output logic [31:0] instr,
                  output logic [31:0] pcplus4);
						
	 logic [31:0] pcnext;
	 logic [31:0] pcplus4;
	 
    mux2 # (32) m2(.in1(pcplus4), 
	                .in2(pcbranch), 
						 .c(PC_SRC),
						 .out(pcnext));
	 
    flopper # (32) next_pc (.clk(clk), 
	                         .reset(reset), 
								    .d(pcnext), 
									 .q(pc_F)); 
	  
    adder   pcadder (.a(pc), 
	                  .b(32'b100), 
						   .sum(pcplus4));
	 
	 InstrMem instr_mem (.addr(pc),
	                     .instr(instr))
    
endmodule