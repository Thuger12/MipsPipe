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
module peripheral_select(input logic memwrite,
                         input logic [31:0] addr,
                         input logic [31:0] writedata,
                       
                         // Will define which peripheral we want to use
                         output logic [1:0] pselect);
    // Low and high bound of MMIO segment
    localparam mmio_low = 32'hffff0000;
    localparam mmio_high = 32'hffff0010;

    localparam uart = 32'hffff0000;
    localparam ethernet_in = 32'hffff0008;
    
    always_comb begin
        if (addr <= mmio_high && addr >= mmio_low) begin
            // Assume that address already aligned
            case addr:
                uart: pselect = 2'b10;
                ethernet: pselect = 2'b11;
                default: begin
                    pselect = 2'b00;
                end
        end else begin
                pselect = 2'b01;
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
module databus_control(input logic clk,
                       input logic reset,
                       input logic [31:0] addr,
                       input logic [31:0] writedata,
                       // It will define what to do(read or write) 
                       input logic memwrite

                       // Signals on bus from peripherals
                       input logic pready,
                       input logic pactive,

                       output logic pwrite_read,
                       output logic [1:0] pselect);

    logic state, next_state;

    localparam idle = 0;
    localparam wait_req = 1;

    logic [1:0] _pselect;
    peripheral_select pselect(.addr(addr),
                              .writedata(writedata),
                              .pselect(_pselect));

    always_ff @(posedge clk) begin
        if (reset) begin
            state <= idle;
        end else begin
                state <= next_state;
            end
    end
    always_comb begin
        case state
        idle: begin
            if (addr && data) begin
                pwrite_read = (memwrite == 1) 1 : 0;
                pselect = _pselect;
                next_state = wait_req;
            end else begin
                    pwrite_read = 0;
                    pselect = 0;
                    next_state = idle;
                end
        end
        wait_req: begin
            if (pready == 1) begin
                // Peripheral is ready => data is ready
                write_read = 0;
                pselect = 0;
            end else begin
                    next_state = wait_req;
                end
        end
    end
endmodule 
