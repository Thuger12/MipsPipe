module latchDecode (input logic clk,
                    input logic reset,
						  input logic [31:0] reg1_D,
						  input logic [31:0] reg2_D,
						  input logic [4:0] rt_D,
						  input logic [4:0] rd_D,
						  input logic [31:0] signimm_D,
						  
				
						  output logic [31:0] reg1_E,
						  output logic [31:0] reg2_E,
						  output logic [4:0] rt_E,
						  output logic [4:0] rd_E,
						  output logic [31:0] signimm_E);
    always_ff @(posedge clk, posedge reset) begin
		if (reset) begin
		    reg1_E <= 0;
			 reg2_E <= 0;
			 rt_E <= 0;
			 rd_E <= 0;
			 signimm_D <= 0;
		end else begin
		        reg1_E <= reg1_D;
				  reg2_E <= reg2_D;
				  rt_E <= rt_D;
				  rd_E <= rd_D;
				  signimm_E <= signimm_D;
		    end
	 end
endmodule
						  