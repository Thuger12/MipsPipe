module bypass (input logic reset,
               input logic [4:0] dec_ex_rs,
               input logic [4:0] dec_ex_rt,
			   
               input logic [4:0] ex_mem_rd,
               input logic [4:0] mem_wb_rd,
                            
               input logic ex_mem_regwrite,
               input logic mem_wb_regwrite,
                            
               output logic [1:0] forward_a,
               output logic [1:0] forward_b);
	
	logic cond_1, cond_2, cond_3, cond_4;
	assign cond_1 = ex_mem_regwrite && (ex_mem_rd != 0) && (ex_mem_rd == dec_ex_rs);
	assign cond_2 = ex_mem_regwrite && (ex_mem_rd != 0) && (ex_mem_rd == dec_ex_rt);
	assign cond_3 = mem_wb_regwrite && (mem_wb_rd != 0) 
            && !(ex_mem_regwrite && (ex_mem_rd != 0) && (ex_mem_rd != dec_ex_rs)) 
            && (mem_wb_rd == dec_ex_rs);
    assign cond_4 = mem_wb_regwrite 
            && (mem_wb_rd != 0) 
            && !(ex_mem_regwrite && (ex_mem_rd != 0) && (ex_mem_rd != dec_ex_rs)) 
            && (mem_wb_rd == dec_ex_rt);
    always_comb begin
        if (cond_1) begin
            forward_a <= 2'b10;
        end 
		if (cond_2) begin
            forward_b <= 2'b10;
		end
        if (cond_3) begin
            forward_a <= 2'b01;
        end 
		if (cond_4) begin
            forward_b <= 2'b01;
        end
		
	end
	
endmodule 
