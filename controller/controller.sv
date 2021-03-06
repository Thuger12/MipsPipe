module controller(input logic clk, 
                  input logic reset,
				  // To remove all signals, that could change arch state
				  // memwrite, writeback, branch
				  input logic stall,
                  // Input
                  input logic [5:0] opcode,
                  input logic [5:0] funct,
                  input logic zero_MEM,
                        
                  // For execute stage 
                  output logic alusrc_EXE, 
                  output logic regdst_EXE,
                  output logic [2:0] alucontrol_EXE,
                        
                  // For memwrite stage
                  output logic regwrite_MEM,
                  output logic memwrite_MEM,
                  output logic pcsrc_MEM,
                        
                  // For write back stage
                  output logic regwrite_WB, 
                  output logic memtoreg_WB);
                        
    // Signals from control unit after decode
    logic regwrite_DEC, memtoreg_DEC, memwrite_DEC, 
          branch_DEC, alusrc_DEC, regdst_DEC;
    logic [2:0] alucontrol_DEC;
    
    logic regwrite_EXE, memtoreg_EXE, memwrite_EXE,
          branch_EXE;
            
    logic memtoreg_MEM, branch_MEM;
    
    // Signal from maindecoder to aludecoder
    logic [1:0] aluop;

    assign pcsrc_MEM = zero_MEM & branch_MEM;   

    maindecoder maindecoder(.opcode(opcode),
                            .regwrite_DEC(regwrite_DEC), 
                            .memtoreg_DEC(memtoreg_DEC),
                            .memwrite_DEC(memwrite_DEC), 
                            .branch_DEC(branch_DEC),
                            .alusrc_DEC(alusrc_DEC), 
                            .regdst_DEC(regdst_DEC), 
                            .aluop(aluop));
                        
    
    aludecoder aludecoder(.funct(funct), 
                          .aluop(aluop), 
                          .alucontrol(alucontrol_DEC));
    
	logic regwrite_DEC_n, memwrite_DEC_n, branch_DEC_n;
	
    mux2 # (3) stall_sigs (.in1({regwrite_DEC, memwrite_DEC, branch_DEC}),
	                        .in2(3'b0),
					        .c(stall),
					        .out({regwrite_DEC_n, memwrite_DEC_n, branch_DEC_n}));
					  
    flopper #(9) exec(clk, reset, 
                        
                            {regwrite_DEC_n, memtoreg_DEC,
                             memwrite_DEC_n, branch_DEC_n,
                             alusrc_DEC, regdst_DEC,
                             alucontrol_DEC},
                        
                            {regwrite_EXE, memtoreg_EXE,
                             memwrite_EXE, branch_EXE,
                             alusrc_EXE, regdst_EXE,
                             alucontrol_EXE});
    
    flopper #(4) memory(clk, reset,
    
                              {regwrite_EXE, memtoreg_EXE,
                               memwrite_EXE, branch_EXE},
                
                              {regwrite_MEM, memtoreg_MEM,
                               memwrite_MEM, branch_MEM});
    
    flopper #(2) writeback(clk, reset, 
                                  // Input
                                  {regwrite_MEM, memtoreg_MEM},
                                  // Output
                                  {regwrite_WB, memtoreg_WB});
endmodule



