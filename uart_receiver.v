`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 27.06.2025 11:59:55
// Design Name: 
// Module Name: uart_rx
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
module uart_receiver(
    input wire clk,               // 100MHz clock
    input wire rx,                // input pin where serial UART data arrives
    output reg [7:0] data_out,    // received 8-bit data
    output reg rx_done,           // high when data is received 
    output reg parity_error,      // high when parity check fails
    output reg led                // LED blinks only when correct data is received
);

parameter BAUD_RATE = 9600;
parameter CLK_FREQ = 100_000_000;
parameter CLKS_PER_BIT = CLK_FREQ / BAUD_RATE;

reg [13:0] clk_count = 0; // counts clk cycles  
reg [3:0] bit_index = 0;  // keeps track of which bit(0 to 7) we are receiving 
reg [7:0] rx_data = 0;    // holds received data bits
reg parity_bit = 0;       // stores received parity bit
reg [1:0] state = 0;      // FSM current state

reg [23:0] led_counter = 0; // keep LED on for some time

localparam IDLE    = 2'b00;  // wait for start bit
localparam START   = 2'b01;  // confirm start bit (after half bit delay)
localparam RECEIVE = 2'b10;  // start collecting data
localparam PARITY  = 2'b11;  // check parity
localparam STOP    = 2'b00;  // loop back to IDLE after stop bit

always @(posedge clk) begin

    if (state == IDLE) begin  // rx = 1
        rx_done <= 0;
        parity_error <= 0;
        clk_count <= 0;
        bit_index <= 0;
        if (rx == 0) begin
            state <= START; // Falling edge = start bit
        end
    end

    else if (state == START) begin  // detected the falling edge (rx = 0)
        if (clk_count == (CLKS_PER_BIT / 2)) begin // wait until half the bit duration
            clk_count <= 0;   // reset the counter for next state
            state <= RECEIVE;    // start receiving data
        end 
        else begin
            clk_count <= clk_count + 1; // wait until mid of start bit
        end 
    end

    else if (state == RECEIVE) begin
        if (clk_count == CLKS_PER_BIT - 1) begin  // wait full 1 bit duration before sampling each bit
            clk_count <= 0; // reset for next bit
            rx_data[bit_index] <= rx; // capture bit
            if (bit_index == 7) begin
                bit_index <= 0;
                state <= PARITY; // next: parity
            end else begin
                bit_index <= bit_index + 1;
            end
        end else begin
            clk_count <= clk_count + 1;
        end
    end

    else if (state == PARITY) begin
        if (clk_count == CLKS_PER_BIT - 1) begin
            clk_count <= 0;  // reset for stop bit
            parity_bit <= rx;
            if (rx != (^rx_data)) begin
                parity_error <= 1; // error if parity doesn't match
            end
            state <= STOP;
        end else begin
            clk_count <= clk_count + 1;
        end
    end

    else if (state == STOP) begin
        if (clk_count == CLKS_PER_BIT - 1) begin
            clk_count <= 0;
            rx_done <= 1;
            data_out <= rx_data;

            if (!parity_error) begin
                led_counter <= 24'd5_000_000; // LED on for ~50 ms
            end

            state <= IDLE;  // loop back
        end else begin
            clk_count <= clk_count + 1;
        end
    end

    //LED blink logic
    if (led_counter > 0) begin
        led <= 1;
        led_counter <= led_counter - 1;
    end else begin
        led <= 0;
    end
end

endmodule

