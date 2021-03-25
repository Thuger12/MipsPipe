/*
 * Module is used to decode address 
 * and redirect data to right place 
 * Actually it's implement to make MMIO
*/

/*
 * CPU got connection to memory and peripherals 
 * through bus that will contain 
 * clk
 * reset
 * addr[31:0]
 * write/read
 * enable(is peripheral active or not)
 * data[31:0]
 * ready 
 */
module address_decoder (input logic memwrite,
                        input logic [31:0] addr,
                        input logic [31:0] writedata,
                        
                        output logic we_mem,
                        // Write enable for devices registers
                        output logic we_uart,
                        output logic we_ethernet);

    // Low and high bound of MMIO segment
    localparam mmio_low = 32'hffff0000;
    localparam mmio_high = 32'hffff0010;

    localparam uart = 32'hffff0000;
    localparam ethernet_in = 32'hffff0008;
    
    always_comb begin
        if (addr <= mmio_high && addr >= mmio_low) begin
            // Assume that address already aligned
            case addr:
                uart: we_uart_in = 1;
                uart_out: we_uart_out = 1;
                ethernet_in: we_ethernet_in = 1;
                ethernet_out: we_ethernet_out = 1;
                default: begin
                    we_uart_in = 0;
                    we_uart_out = 0;
                    we_ethernet_in = 0;
                    we_ethernet_out = 0;
                end
        end else begin
               we_mem = 1; 
               we_uart_in = 0;
               we_uart_out = 0;
               we_ethernet_in = 0;
               we_ethernet_out = 0;
            end
    end
endmodule

/*
 * This module will control signals like 
 * write/read, penable, ready
 * Depending on str or ldr command it will 
 * setup right signals
 * After it get all data it will supply it 
 * directly to cpu
 */
module peripheral_control(input logic clk,
                          input logic reset,
                      );
    case command
        store: write_read = 1;
        load: write_read = 0;

endmodule 
