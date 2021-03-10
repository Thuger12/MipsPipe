/*
 * Control flow module will manage all control flow 
 * occurance(branch), pipeline stalls, pipelines flashes
 * It's also will in charge of make output of register file
*/
module control_flow (input logic memtoreg_MEM,
                     input logic [4:0] rs_DEC,
                     input logic [4:0] rt_DEC,
					 input logic [4:0] rt_EXE,
                     output logic stall_IF,
					 output logic stall_DEC,
					 output logic flush_EXE
					 output logic flush_control_signals);
					   
	always_comb begin	
        if (memtoreg_MEM && (rs_DEC == rt_EXE) || (rt_DEC == rt_EXE)) begin
		    stall_IF <= 1;
			stall_DEC <= 1;
			flush_EXE <= 1;
			flush_control_signals <= 1;
        end		
	end
endmodule 
