/*
 * Module is used to decode address 
 * and redirect data to right place 
 * Actually it's implement to make MMIO
*/

module address_decoder (input logic memwrite,
                        input logic [31:0] addr,
                        input logic [31:0] writedata,
                        
                        output logic we_mem,
                        // Write enable for devices registers
                        output logic we_1,
                        output logic we_2,
                        output logic [2:0] readdata_dst);

    // Low and high bound of MMIO segment
    localparam mmio_low = 32'hffff0000;
    localparam mmio_high = 32'hffff0010;

endmodule
