module latch_memory (input logic clk,
                 input logic reset,
					  input logic [31:0] aluresult_MEM,
					  input logic [31:0] readdata_MEM,
					  input logic [4:0] writereg_MEM,
					  
					  output logic [31:0] aluresult_WB,
					  output logic [31:0] readdata_WB,
					  output logic [4:0] writereg_WB);
		
    always_ff @(posedge clk, posedge reset) begin
	     if (reset) begin
		      aluresult_WB <= 0;
				readdata_WB <= 0;
				writereg_WB <= 0; 
		  end else begin
		          aluresult_WB <= aluresult_MEM;
					 readdata_WB <= readdata_MEM;
					 writereg_WB <= writereg_MEM;
		      end
	 end
endmodule 