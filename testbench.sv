module mips_testbench();
	logic CLK, RESET;
	logic [31:0] writedata, dataaddr, instr;
	logic [31:0] pc;
	logic MEMWRITE; // For enabling writing
	
	// Device under test
	top dut(CLK, RESET, writedata, dataaddr, instr, MEMWRITE, pc);
	initial begin
		RESET = 1;
		#12
		RESET = 0;
	end
	
	always 
		begin
			CLK <= 1; # 20; CLK <= 0; # 20;
		end
	
	always @(negedge CLK)
		begin
			$display("Dataaddr is %b", dataaddr);
			$display("Writedata is %b", writedata);
			$display("Instr is %b", instr);
			$display("Pc is %b\n", pc);
		end	
endmodule 


module top(input logic CLK, 
           input logic RESET,
			  output logic [31:0] writedata, dataaddr, instr,
			  output logic MEMWRITE,
			  output logic [31:0] o_pc );
			  
	logic [31:0] pc, readdata;
	assign o_pc = pc;
	mips 			mips1(CLK, RESET, instr, readdata,
						  pc, MEMWRITE, dataaddr, writedata);
						  
	datamemory  dmemory(CLK, MEMWRITE, dataaddr, writedata, readdata);
	instrmemory imemory(pc[7:2], instr);
	
endmodule 


module datamemory(input logic CLK, MEMWRITE,
						input logic [31:0] dataaddr,
						input logic [31:0] writedata,
						output logic [31:0] readdata);
						
	logic [31:0] RAM [31:0];
	assign readdata = RAM[dataaddr[31:2]];
	
	always_ff @(posedge CLK)
		if (MEMWRITE) RAM[dataaddr[31:2]] <= writedata;
		
endmodule


module instrmemory(input logic [5:0] addr, // for 64 words
						 output logic [31:0] data);
	logic [31:0] RAM [63:0];
	initial 
		$readmemh("C:/intelFPGA_lite/MIPS-main/test.txt", RAM);
	assign data = RAM[addr];
endmodule 
						
