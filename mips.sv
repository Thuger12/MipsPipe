module mips(input logic clk, 
            input logic reset,
			input logic clear);
                
    // Signals for execute stage
    logic alusrc_EXE, regdst_EXE;
    logic [2:0] alucontrol_EXE;
    
    // Signals for memory stage
    logic regwrite_MEM, memwrite_MEM, pcsrc_MEM;  

    // Signals for writeback stage
    logic regwrite_WB, memtoreg_WB;
            
  
    logic [31:0] pcplus4_IF, instr_IF;
    
    logic [31:0] instr_DEC, pcplus4_DEC;
    logic [31:0] reg1_DEC, reg2_DEC, signimm_DEC;
    logic [4:0] rt_DEC, rd_DEC, rs_DEC;
    
    logic [31:0] reg1_EXE, reg2_EXE, signimm_EXE, pcplus4_EXE;
    logic [4:0] rt_EXE, rd_EXE, rs_EXE;
    logic [4:0] writereg_EXE;
    logic [31:0] aluresult_EXE, writedata_EXE, pcbranch_EXE;
    logic zero_EXE, overflow_EXE;
    
    logic [31:0] aluresult_MEM, writedata_MEM, pcbranch_MEM;
    logic [4:0] writereg_MEM;
    logic [31:0] readdata_MEM;
    logic zero_MEM;
    
    logic [31:0] aluresult_WB, readdata_WB;
    logic [31:0] result_WB;
    logic [4:0]  writereg_WB;
                          
	 logic stall;

    logic [1:0] forward_a, forward_b;

    bypass bypass(.dec_ex_rs(rs_EXE),
                  .dec_ex_rt(rt_EXE),
                  .ex_mem_rd(writereg_MEM),
                  .mem_wb_rd(writereg_WB),

                  .ex_mem_regwrite(regwrite_MEM),
                  .mem_wb_regwrite(regwrite_WB),
                  
                  .forward_a(forward_a),
                  .forward_b(forward_b));

    controller control (.clk(clk),
                        .reset(reset),
								.stall(stall),
                        .opcode(instr_DEC[31:26]),
                        .funct(instr_DEC[5:0]),
                        .zero_MEM(zero_MEM),
                        .alusrc_EXE(alusrc_EXE),
                        .regdst_EXE(regdst_EXE),
                        .alucontrol_EXE(alucontrol_EXE),
                        .regwrite_MEM(regwrite_MEM),
                        .memwrite_MEM(memwrite_MEM),
                        .pcsrc_MEM(pcsrc_MEM),
                        .regwrite_WB(regwrite_WB),
                        .memtoreg_WB(memtoreg_WB));
    //
    // Latching pipeline results
    // 
    latch_fetch latch_fetch (.clk(clk),
                             .reset(reset),
									  .stall(stall),
                             .instr_IF(instr_IF),
                             .pcplus4_IF(pcplus4_IF),
                             
                             .instr_DEC(instr_DEC),
                             .pcplus4_DEC(pcplus4_DEC));
    
    latch_decode latch_decode (.clk(clk),
                               .reset(reset),
										 .clear(clear),
                               .reg1_DEC(reg1_DEC),
                               .reg2_DEC(reg2_DEC),
                               .rt_DEC(rt_DEC),
                               .rd_DEC(rd_DEC),
							   .rs_DEC(rs_DEC),
                               .signimm_DEC(signimm_DEC),
                               .pcplus4_DEC(pcplus4_DEC),
                                
                               .reg1_EXE(reg1_EXE),
                               .reg2_EXE(reg2_EXE),
                               .rt_EXE(rt_EXE),
                               .rd_EXE(rd_EXE),
							   .rs_EXE(rs_EXE),
                               .signimm_EXE(signimm_EXE),
                               .pcplus4_EXE(pcplus4_EXE));
                                
    latch_execute latch_execute (.clk(clk),
                                 .reset(reset),
                                 .zero_EXE(zero_EXE),
                                 .aluresult_EXE(aluresult_EXE),
                                 .writedata_EXE(writedata_EXE),
                                 .writereg_EXE(writereg_EXE),
                                 .pcbranch_EXE(pcbranch_EXE),
                                  
                                 .zero_MEM(zero_MEM),
                                 .aluresult_MEM(aluresult_MEM),
                                 .writedata_MEM(writedata_MEM),
                                 .writereg_MEM(writereg_MEM),
                                 .pcbranch_MEM(pcbranch_MEM));
                                  
    latch_memory latch_mem (.clk(clk),
                            .reset(reset),
                            .aluresult_MEM(aluresult_MEM),
                            .readdata_MEM(readdata_MEM),
                            .writereg_MEM(writereg_MEM),
                                    
                            .aluresult_WB(aluresult_WB),
                            .readdata_WB(readdata_WB),
                            .writereg_WB(writereg_WB));
    //
    // Pipeline stages
    //
    

    
    stage_fetch fetch (.clk(clk),
                       .reset(reset),
							  .stall(stall),
                       .pcbranch(pcbranch_MEM),
                       .pcsrc(pcsrc_MEM),
                            
                       .instr(instr_IF),
                       .pcplus4(pcplus4_IF));
                            
    stage_decode decode (.clk(clk),
                         .reset(reset),
                         .instr(instr_DEC),
                         .regwrite_WB(regwrite_WB),
                         .result_WB(result_WB),
                         .writereg_WB(writereg_WB),
                                
                         .rt(rt_DEC),
                         .rd(rd_DEC),
						 .rs(rs_DEC),
                         .reg1(reg1_DEC),
                         .reg2(reg2_DEC),
                         .signimm(signimm_DEC));
                                
    stage_execute execute (.clk(clk),
                           .reset(reset),
                           .alusrc(alusrc_EXE),
                           .regdst(regdst_EXE),
                           .alucontrol(alucontrol_EXE),
                           .reg1(reg1_EXE),
                           .reg2(reg2_EXE),
                           .rt(rt_EXE),
                           .rd(rd_EXE),
                           .signimm(signimm_EXE),
                           .pcplus4(pcplus4_EXE),
                           
                           .aluresult_MEM(aluresult_MEM),
                           .result_WB(result_WB),
                           .forward_a(forward_a),
                           .forward_b(forward_b),
                                  
                           .aluresult(aluresult_EXE),
                           .zero(zero_EXE),
                           .overflow(overflow_EXE),
                           .writereg(writereg_EXE),
                           .writedata(writedata_EXE),
                           .pcbranch(pcbranch_EXE));
                                  
    stage_memory memory (.clk(clk),
                         .reset(reset),
                         .memwrite(memwrite_MEM),
                         .dataaddr(aluresult_MEM),
                         .writedata(writedata_MEM),
                                
                         .readdata(readdata_MEM));
                                
    stage_writeback writeback (.memtoreg(memtoreg_WB),
                               .readdata(readdata_WB),
                               .aluresult(aluresult_WB),
                               .result(result_WB));   
endmodule 
