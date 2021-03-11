module branch_control (input logic pcsrc_MEM,
                       output logic flush_if,
                       output logic flush_if_dec,
							  output logic flush_dec_exe);
	always_comb begin
	    if (pcsrc_MEM) begin
		     flush_if = 1'b1;
			  flush_if_dec = 1'b1;
			  flush_dec_exe = 1'b1; 
		 end else begin
		         flush_if = 1'b1;
					flush_if_dec = 1'b1;
					flush_dec_exe = 1'b1;
		     end 
	end
endmodule 