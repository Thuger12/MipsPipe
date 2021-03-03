module maindecoder (input logic [5:0] opcode,
                    output logic regwrite_DEC, 
						  output logic memtoreg_DEC,
                    output logic memwrite_DEC, 
						  output logic branch_DEC,
                    output logic alusrc_DEC, 
						  output logic regdst_DEC,
                    output logic [1:0] aluop);
						 
	always_comb
		case (opcode)
		// R type depends on funct
			6'b000000: begin 
				memtoreg_DEC <= 1'b0;
				memwrite_DEC <= 1'b0;
				regdst_DEC   <= 1'b1;
				regwrite_DEC <= 1'b1;
				alusrc_DEC   <= 1'b0;
				branch_DEC   <= 1'b0;
				aluop      <= 2'b10;
			end
			// LD
			6'b100011: begin
				memtoreg_DEC <= 1'b1;
				memwrite_DEC <= 1'b0;
				regdst_DEC   <= 1'b0;
				regwrite_DEC <= 1'b1;
				alusrc_DEC   <= 1'b1;
				branch_DEC   <= 1'b0;
				aluop      <= 2'b0;
			end
			// ST
			6'b101011: begin
				memtoreg_DEC <= 1'b0;
				memwrite_DEC <= 1'b1;
				regdst_DEC   <= 1'b0;
				regwrite_DEC <= 1'b0;
				alusrc_DEC   <= 1'b1;
				branch_DEC   <= 1'b0;
				aluop      <= 2'b00;
			end
			// BEQ
			6'b000100: begin
				memtoreg_DEC <= 1'b0;
				memwrite_DEC <= 1'b0;
				regdst_DEC   <= 1'b0;
				regwrite_DEC <= 1'b0;
				alusrc_DEC   <= 1'b0;
				branch_DEC   <= 1'b1;
				aluop      <= 2'b01;
			end
			// ADDI
			6'b001000: begin
				memtoreg_DEC <= 1'b0;
				memwrite_DEC <= 1'b0;
				regdst_DEC   <= 1'b0;
				regwrite_DEC <= 1'b1;
				alusrc_DEC   <= 1'b1;
				branch_DEC   <= 1'b0;
				aluop      <= 2'b0;
			end
			// J
			6'b000010: begin
				memtoreg_DEC <= 1'b0;
				memwrite_DEC <= 1'b0;
				regdst_DEC   <= 1'b0;
				regwrite_DEC <= 1'b1;
				alusrc_DEC   <= 1'b1;
				branch_DEC   <= 1'b0;
				aluop      <= 2'b0;
			end
			// ILLEGAL
			default: begin
				memtoreg_DEC <= 1'b0;
				memwrite_DEC <= 1'b0;
				regdst_DEC   <= 1'b0;
				regwrite_DEC <= 1'b0;
				alusrc_DEC   <= 1'b0;
				branch_DEC   <= 1'b0;
				aluop      <= 2'b0;
			end
		endcase	 
endmodule
