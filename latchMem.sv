module latchMem (input logic clk,
                 input logic reset,
					  input logic [31:0] aluresult_M,
					  input logic [31:0] readdata_M,
					  input logic [4:0] writereg_M,
					  
					  output logic [31:0] aluresult_WB,
					  output logic [31:0] readdata_WB,
					  output logic [4:0] writereg_WB);
		
    always_ff @(posedge clk, posedge reset) begin
	     if (reset) begin
		      aluresult_WB <= 0;
				readdata_WB <= 0;
				writereg_WB <= 0; 
		  end else begin
		          aluresult_WB <= aluresult_M;
					 readdata_WB <= readdata_M;
					 writereg_WB <= writereg_WB;
		      end
	 end
endmodule 