module DatapathTestbench();
	logic clk, reset;
	logic pcsrc;
	logic [2:0] alucontrol;
	logic alusrc, regdst;
	
	logic o_zero;
	
	logic regwrite, memtoreg;

	logic [31:0] instr, readdata;
	
	logic [31:0] o_pc, o_aluresult;
	logic [31:0] o_writedata, o_instr_contr;
	
	// Device under test
	datapath dut(clk, reset, 
	             pcsrc,
					 alucontrol,
					 alusrc, regdst,
					 o_zero,
					 regwrite, memtoreg,
					 instr, readdata,
					 o_pc,
					 o_aluresult,
					 o_writedata,
					 o_instr_contr);
		
	always 
		begin
		   pcsrc <= 0;
			clk <= 1; # 30; clk <= 0; # 30;
		end
	
//	always @(negedge CLK)
//		begin
//			$display("Dataaddr is %b", dataaddr);
//			$display("Writedata is %b", writedata);
//			$display("Instr is %b", instr);
//		end	

	logic [32:0] testvector [10:0];
	logic [31:0] vectnum, errors;
	logic [8:0] expected;

	always @(posedge clk) begin
	    instr = testvector[vectnum];
	end
	
	always @(negedge clk) begin
		vectnum = vectnum + 1;
		if (testvector[vectnum] === 32'b0) begin
			$finish;
		end
	end
	initial 
		begin
			$readmemh("C:/intelFPGA_lite/MIPS-main/datapathTest.txt", testvector);
			reset = 1;
			#15;
			reset = 0;
			vectnum = 0;
			errors = 0;
		end
endmodule 