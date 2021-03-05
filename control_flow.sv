/*
 * Control flow module will manage all control flow 
 * occurance(branch), pipeline stalls, pipelines flashes
 * It's also will in charge of make output of register file
*/
module control_flow (input logic [4:0] rt_DEC,
                     input logic [4:0] rd_DEC,
					 input logic [4:0] rd_EXE,
                     output logic stall_IF,
					 output logic stall_DEC,
					 output logic flush_EXE);
endmodule 
