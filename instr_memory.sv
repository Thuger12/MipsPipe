module instr_memory (input logic [31:0] addr,
							output logic [31:0] instr);
							
	logic [31:0] instr_mem [0:1];
	
	initial begin
	 $readmemh("Y:/Oleg/HDL/MIPS-main/instr_set.txt", instr_mem);
	end
	
	assign instr = instr_mem[addr>>2];
endmodule 