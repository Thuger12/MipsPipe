module datapath(input logic clk,
                input logic reset,
                input logic PCSRC_M,
                //Signal on execute stage
                input logic [2:0] ALUCONTROL_E,
                input logic ALUSRC_E,
                input logic REGDST_E,
                     
                // Signal on writememory stage
                output logic o_ZERO_M,
                     
                // Signal on writeback stage
                input logic REGWRITE_WB,
                input logic MEMTOREG_WB,
                
                input logic [31:0] instr,
                input logic [31:0] readdata, // Data from memory
                output logic [31:0] pc,
                output logic [31:0] aluresult,
                output logic [31:0] writedata,
                output logic [31:0] instr_D_control); 

    // Data on fetch stage
    logic [31:0] pc_F; 
    logic [31:0] pcplus4_F, instr_F;

    assign pc = pc_F;
    assign instr_F = instr;
    
    // Data on decode stage
    logic [31:0] instr_D, pcplus4_D;
     
    logic [31:0] reg1_D, reg2_D, signimm_D;
    logic [4:0]  rt_D, rd_D;
    assign instr_D_control = instr_D;
    assign rt_D = instr_D[20:16];
    assign rd_D = instr_D[15:11];

    // Data on execute stage
    logic [31:0] reg1_E, reg2_E,
                 signimm_E, pcplus4_E; 
    logic [4:0] rt_E, rd_E;

    logic [31:0] aluresult_E, pcbranch_E;
    logic [31:0] writedata_E;
    logic [4:0] writereg_E;
    logic ZERO_E;
    
    // Data on memory stage
    logic [31:0] aluresult_M, writedata_M, pcbranch_M;
    logic [4:0] writereg_M;  
    logic [31:0] readdata_M;

    assign aluresult = aluresult_M;
    assign readdata_M = readdata;
    assign writedata = writedata_M;
    
    // Data on writeback stage
    logic [31:0] aluresult_WB, readdata_WB;
    logic [31:0] result_WB;
    logic [4:0]  writereg_WB;
     
    
    // Latching fetch result
    flopper # (32) instr_Fetch(clk, reset, instr_F, instr_D);
    flopper # (32) pcplus4_Fetch(clk, reset, pcplus4_F, pcplus4_D);

     // Latching decode result
    flopper # (32) reg1_Decode(clk, reset, reg1_D, reg1_E);
    flopper # (32) reg2_Decode(clk, reset, reg2_D, reg2_E);
    flopper # (5)  rt_Decode(clk, reset, rt_D, rt_E);
    flopper # (5)  rd_Decode(clk, reset, rd_D, rd_E);
    flopper # (32) signimm_Decode(clk, reset, signimm_D, signimm_E);
    flopper # (32) pcplus4_Decode(clk, reset, pcplus4_D, pcplus4_E);
   
     // Latching execute result
    signalFlopper  zero_Execute(clk, reset, ZERO_E, o_ZERO_M);
    flopper # (32) alures_Execute(clk, reset, aluresult_E, aluresult_M);
    flopper # (32) writedata_Execute(clk, reset, reg2_E, writedata_M);
    flopper # (5)  writereg_Execute(clk, reset, writereg_E, writereg_M);
    flopper # (32) pcbranch_Execute(clk, reset, pcbranch_E, pcbranch_M);

     // Latching memory result
    flopper # (32) aluresult_Memory(clk, reset, aluresult_M, aluresult_WB);
    flopper # (32) memdata_Memory(clk, reset, readdata_M, readdata_WB);
    flopper # (5)  writereg_Memory(clk, reset, writereg_M, writereg_WB);
endmodule







