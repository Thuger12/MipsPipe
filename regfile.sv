module regfile(input logic clk,
					input logic writeenable,
					input logic halt,
					input logic [4:0] ra1, 
					input logic [4:0] ra2, 
					input logic [4:0] ra3,
					input logic [31:0] wd3,
					
					output logic [31:0] rd1, 
					output logic [31:0] rd2);
	// Register matrices stores 32 of 32bits
	logic [31:0] regf [0:31];
	
	// Seq logic, because writing only allow by clock
	always_ff @(posedge clk) begin
		if (writeenable) regf[ra3] <= wd3;
	end

	assign rd1 = (ra1 != 0) ? regf[ra1] : 32'b0;
	assign rd2 = (ra2 != 0) ? regf[ra2] : 32'b0;
	
	integer i;
	
	always_ff @(negedge clk) begin
	    $display("***Register file***");
			
		 for (i = 0; i < 32; i = i + 1) begin
		     $display("%d - 0x%0h", i, regf[i]);
		 end
		 
		 $display("***End of register file***");
	end
endmodule