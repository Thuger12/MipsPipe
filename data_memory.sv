module data_memory (input logic clk,
                    input logic reset,
						  input logic writeenable,
						  input logic [31:0] addr,
						  input logic [31:0] writedata,
						  output logic [31:0] readdata);
						  
	logic [31:0] data_mem [0:1023];
	
	always_ff @(posedge clk) begin
	    if (writeenable) begin
		     data_mem[addr] <= writedata;
		 end
	end
	
	assign readdata = data_mem[addr];
endmodule 