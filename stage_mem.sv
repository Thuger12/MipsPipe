module stage_memory (input logic clk,
                     input logic reset,
					      input logic memwrite,
					      input logic [31:0] dataaddr,
					      input logic [31:0] writedata,
					      output logic [31:0] readdata);
					   
	data_memory dmem (.clk(clk),
	                  .reset(reset),
							.addr(dataaddr),
							.writeenable(memwrite),
							.writedata(writedata),
							.readdata(readdata));
endmodule 