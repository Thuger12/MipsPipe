module latchFetch (input logic clk,
                   input logic reset,
						 input logic [31:0] instr_F,
						 input logic [31:0] pcplus4_F,
						 
						 output logic [31:0] instr_D,
						 output logic [31:0] pcplus4_D);
	always_ff (posedge clk, posedge reset) begin
	    if (reset) begin
		     instr_D <= 0;
			  pcplus4_D <= 0;
		 end else begin
		         instr_D <= instr_F;
					pcplus4_D <= pcplus4_F;
		     end
	end
endmodule
						 