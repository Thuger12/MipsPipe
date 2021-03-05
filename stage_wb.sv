module stage_writeback (input logic memtoreg,
                        input logic [31:0] readdata,
                        input logic [31:0] aluresult,
                        output logic [31:0] result);
                     
    mux2 # (32) res_wb (.in1(aluresult),
                        .in2(readdata),
                        .c(memtoreg),
                        .out(result));
endmodule 