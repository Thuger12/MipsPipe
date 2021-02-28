module stageExecute (input logic clk, 
                     input logic reset,
                     // Signal
                     input logic ALUSRC, 
							input logic REGDST,
                     input logic [2:0] ALUCONTROL,
                     // Data
                     input logic [31:0] reg1, 
							input logic [31:0] reg2,
                     input logic [4:0] rt, 
							input logic [4:0] rd,
                     input logic [31:0] signimm, 
							input logic [31:0] pcplus4,

                     output logic [31:0] aluresult,
                     output logic zero,
							output logic overflow,

                     output logic [4:0] writereg,
                     output logic [31:0] pcbranch);

    logic [31:0] srca, srcb;
	 assign srca = reg1;
	 
    // Choose between register and sign immediate value
    mux2 # (32) m1(.in1(reg2), 
	                .in2(signimm), 
						 .c(ALUSRC), 
						 .out(srcb));
						 
    mux2 # (5) m2(.in1(rt), 
	               .in2(rd), 
						.c(REGDST), 
						.out(writereg));
	 
    alu # (32) alu(.src_a(srca), 
	                .src_b(srcb), 
						 .control(ALUCONTROL_E), 
						 .zero(zero), 
						 .overflow(overflow), 
						 .aluresult(aluresult));

    logic  [31:0] signimmsh;
	 
    shiftleft2 sh2(.a(signimm), 
	                .y(signimmsh));

    adder pcadder(.a(signimmsh), 
	               .b(pcplus4), 
						.sum(pcbranch));
endmodule