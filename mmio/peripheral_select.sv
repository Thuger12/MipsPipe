module peripheral_select(input logic [31:0] addr,
                         input logic [31:0] writedata,
                       
                         // Will define which peripheral we want to use
                         output logic [1:0] pselect);
    // Low and high bound of MMIO segment
    localparam mmio_low = 32'hffff0000;
    localparam mmio_high = 32'hffff0010;

    localparam uart = 32'hffff0000;
    localparam ethernet = 32'hffff0008;
    
    always_comb begin
        if (addr <= mmio_high && addr >= mmio_low) begin
            // Assume that address already aligned
            case (addr)
                uart: pselect = 2'b10;
                ethernet: pselect = 2'b11;
                default: begin
                    pselect = 2'b00;
                end
            endcase
        end else begin
                pselect = 2'b01;
            end
    end
endmodule
