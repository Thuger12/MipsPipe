module bypass (input logic [4:0] dec_ex_rs,
               input logic [4:0] dec_ex_rt,
					input logic [4:0] ex_mem_rd,
					input logic [4:0] ex_mem_aluresult,
					input logic [4:0] mem_wb_rd,
							
					input logic ex_mem_regwrite,
					input logic mem_wb_regwrite,
							
					output logic [1:0] forward_a,
					output logic [1:0] forward_b);
	if (ex_mem_regwirte && (ex_mem_rd != 0) && (ex_mem_rd == dec_ex_rs)) begin
	    forward_a <= 2'b10;
	end
	if (ex_mem_regwrite && (ex_mem_rd != 0) && (ex_mem_rd == dec_ex_rt)) begin
	    forward_b <= 2'b10;
	end
	
	if (mem_wb_regwrite && (mem_wb_rd != 0) 
	    && !(ex_mem_regwrite && (ex_mem_rd != 0) && (ex_mem_rd != dec_ex_rs)) 
		 && (mem_wb_rd == dec_ex_rs)) begin
	    forward_a <= 2'b01;
	end
	if (mem_wb_regwrite 
	    && (mem_wb_rd != 0) 
		 && !(ex_mem_regwrite && (ex_mem_rd != 0) && (ex_mem_rd != dec_ex_rs)) 
		 && (mem_wb_rd == dec_ex_rt)) begin
	    forward_b <= 2'b01;
	end
    
endmodule 