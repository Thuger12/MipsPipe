//	-- regfile
//	-- adder
//	-- shiftleft for 2 bits
//	-- signextend from 16 to 32 (arithmetic)
//	-- trigger (clk, reset)
//	-- multiplexor (2 x 1)





module adder (input logic [31:0] a, 
              input logic [31:0] b,
				  output logic [31:0] sum);
	assign sum = a + b;
endmodule


module shiftleft2 (input logic [31:0] a,
					    output logic [31:0] y);
	assign y = {a[29:0], 2'b00};
endmodule
					 

module signextend(input logic [15:0] a,
						output logic [31:0] y);
	assign y = {{16{a[15]}}, a};
endmodule 

module signalFlopper(input logic clk, reset,
                      input logic d,
							 output logic q);
    always_ff @(posedge clk, posedge reset) begin 
		if (reset) q <= 0;
		else q <= d;
	 end
endmodule

module flopper # (parameter WIDTH = 8)
					  (input logic clk, 
					   input logic reset,
						input logic [WIDTH-1:0] d,
						output logic [WIDTH-1:0] q);
						
	always_ff @(posedge clk, posedge reset)
		if (reset) q <= 0;
		else       q <= d;
endmodule

// Multipleksor 2 x 1
module mux2 # (parameter WIDTH = 8)
				  (input logic [WIDTH-1:0] in1, 
				   input logic [WIDTH-1:0] in2,
				   input logic c,
					output logic [WIDTH-1:0] out);
	assign out = c ? in2 : in1;
endmodule

module alu # (parameter WIDTH = 8)
				 (input logic [WIDTH-1:0] src_a, 
				  input logic [WIDTH-1:0] src_b,
				  input logic [2:0] control,
				  
				  output logic zero, 
				  output logic overflow, 
				  output logic [WIDTH-1:0] result);
	logic [WIDTH-1:0] bout;
	logic [WIDTH-1:0] sum;
	
	assign bout = control[2] ? ~src_b : src_b;
	assign sum = src_a + bout + control[2];
	
	always_comb
		case (control[1:0])
			2'b00: result <= src_a & bout;
			2'b01: result <= src_a | bout;
			2'b10: result <= sum;
			2'b11: result <= sum[31];
		endcase
		
	assign zero = (result == 32'b0);
	
	always_comb
		case (control[2:1])
			2'b01: overflow <= src_a[31] & src_b[31] & ~sum[31] |
									 ~src_a[31] & ~src_b[31] & sum[31];
			2'b11: overflow <= ~src_a[31] & src_b[31] & sum[31] |
									 src_a[31] & ~src_b[31] & ~sum[31];
			default: overflow <= 1'b0;
		endcase
endmodule 
