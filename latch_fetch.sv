module latch_fetch (input logic clk,
                    input logic reset,
					     input logic stall,
                    input logic [31:0] instr_IF,
                    input logic [31:0] pcplus4_IF,
                         
                    output logic [31:0] instr_DEC,
                    output logic [31:0] pcplus4_DEC);

    always_ff @(posedge clk, posedge reset) begin
	     if (reset) begin
            instr_DEC <= 0;
            pcplus4_DEC <= 0;
        end else begin
            instr_DEC <= instr_IF;
            pcplus4_DEC <= pcplus4_IF;
            end
    end
endmodule
                         