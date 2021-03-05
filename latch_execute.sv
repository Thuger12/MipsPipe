module latch_execute (input logic clk,
                      input logic reset,
						    input logic zero_EXE,
						    input logic [31:0] aluresult_EXE,
						    input logic [31:0] writedata_EXE,
						    input logic [4:0] writereg_EXE,
						    input logic [31:0] pcbranch_EXE,
						  
						    output logic zero_MEM,
						    output logic [31:0] aluresult_MEM,
						    output logic [31:0] writedata_MEM,
						    output logic [4:0] writereg_MEM,
						    output logic [31:0] pcbranch_MEM);
						  
    always_ff @(posedge clk, posedge reset) begin
	     if (reset) begin
		      zero_MEM <= 0;
				aluresult_MEM <= 0;
				writedata_MEM <= 0;
				writereg_MEM <= 0;
				pcbranch_MEM <= 0;
			end else begin
			        zero_MEM <= zero_EXE;
					  aluresult_MEM <= aluresult_EXE;
					  writedata_MEM <= writedata_EXE;
					  writereg_MEM <= writereg_EXE;
					  pcbranch_MEM <= pcbranch_EXE;
			    end
	 end
endmodule 