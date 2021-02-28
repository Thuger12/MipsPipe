module latchExe (input logic clk,
                    input logic reset,
						  input logic zero_E,
						  input logic [31:0] aluresult_E,
						  input logic [31:0] writedata_E,
						  input logic [31:0] writereg_E,
						  input logic [31:0] pcbranch_E,
						  
						  output logic zero_M,
						  output logic [31:0] aluresult_M,
						  output logic [31:0] writedata_M,
						  output logic [5:0] writereg_M,
						  output logic [31:0] pcbranch_M);
						  
    always_ff @(posedge clk, posedge reset) begin
	     if (reset) begin
		      zero_M <= 0;
				aluresult_M <= 0;
				writedata_M <= 0;
				writereg_M <= 0;
				pcbranch_M <= 0;
			end else begin
			        zero_M <= zero_E;
					  aluresult_M <= aluresult_E;
					  writedata_M <= writedata_E;
					  writereg_M <= writereg_E;
					  pcbranch_M <= pcbranch_E;
			    end
	 end
endmodule 