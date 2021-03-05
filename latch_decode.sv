module latch_decode (input logic clk,
                     input logic reset,
                     input logic [31:0] reg1_DEC,
                     input logic [31:0] reg2_DEC,
                     input logic [4:0] rt_DEC,
                     input logic [4:0] rd_DEC,
                     input logic [31:0] signimm_DEC,
                     input logic [31:0] pcplus4_DEC,
                          
                
                     output logic [31:0] reg1_EXE,
                     output logic [31:0] reg2_EXE,
                     output logic [4:0] rt_EXE,
                     output logic [4:0] rd_EXE,
                     output logic [31:0] signimm_EXE,
                     output logic [31:0] pcplus4_EXE);
                 
    always_ff @(posedge clk, posedge reset) begin
        if (reset) begin
            reg1_EXE <= 0;
            reg2_EXE <= 0;
            rt_EXE <= 0;
            rd_EXE <= 0;
            signimm_EXE <= 0;
            pcplus4_EXE <= 0;
        end else begin
                reg1_EXE <= reg1_DEC;
                reg2_EXE <= reg2_DEC;
                rt_EXE <= rt_DEC;
                rd_EXE <= rd_DEC;
                signimm_EXE <= signimm_DEC;
                pcplus4_EXE <= pcplus4_DEC;
            end
     end
endmodule
                          
