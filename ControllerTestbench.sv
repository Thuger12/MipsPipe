module ControllerTestbench();
	logic CLK, RESET;
	logic [5:0] opcode, funct;
	logic ZERO_M;
	
	logic REGWRITE_E, MEMTOREG_E, MEMWRITE_E,
	      BRANCH_E, ALUSRC_E, REGDST_E;
	logic [2:0] ALUCONTROL_E;
	
	logic REGWRITE_M, MEMTOREG_M, MEMWRITE_M,
	      BRANCH_M, PCSRC_M;
	
	logic REGWRITE_WB, MEMTOREG_WB;
	
	controller dut(CLK, RESET,
	               opcode, funct,
						ZERO_M,
						REGWRITE_E, MEMTOREG_E, MEMWRITE_E,
                  BRANCH_E, ALUSRC_E, REGDST_E,
                  ALUCONTROL_E,
 
                  REGWRITE_M, MEMTOREG_M, MEMWRITE_M,
                  BRANCH_M, PCSRC_M,

                  REGWRITE_WB, MEMTOREG_WB);
						
	logic [8:0] executeOut;
	assign executeOut = {MEMTOREG_E, MEMWRITE_E, REGDST_E, REGWRITE_E, ALUSRC_E, BRANCH_E, ALUCONTROL_E};
	
	logic [11:0] testvector [10:0];
	logic [31:0] vectnum, errors;
	logic [8:0] expected;

	always 
		begin
		    CLK <= 1; #20; CLK <= 0; #20;
		end
		

	initial 
		begin
			$readmemb("C:/intelFPGA_lite/MIPS-main/controllerTest.txt", testvector);
			vectnum = 0;
			errors = 0;
		end
	
	always @(posedge CLK) begin
	    {opcode, funct} = testvector[vectnum];
	end
	
	always @(negedge CLK) begin
		$display ("Current input: opcode:%b funct:%b", opcode, funct);
		vectnum = vectnum + 1;
		if (testvector[vectnum] === 12'b0) begin
			$display ("Test completed. Errors: %b", errors);
			$finish;
		end
	end
	    
endmodule 