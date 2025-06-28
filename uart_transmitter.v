`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 26.06.2025 16:16:55
// Design Name: 
// Module Name: uart_tx
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


module uart_transmitter(
    input wire clk,               //100 Mhz clock
    input wire start,             //start signal
    input wire [7:0] data_in,     //8 bit data
    output reg tx,                //UART serial output
    output reg tx_busy,           //Indicates transmission in progress
    output reg tx_done,           //High for one cycle after transmission done or signal sending is complete comp
    output reg led                //LED blinks to show that transmission was done
);

parameter BAUD_RATE = 9600;
parameter CLK_FREQ = 100_000_000;
parameter CLKS_PER_BIT = CLK_FREQ / BAUD_RATE;

reg [13:0] clk_count = 0; //counts from 0 to 10416 (10417 clock cycles) - then reset and change to next bit
                          // 2^13=8191(too small),2^14=16383>=10417(perfect),2^15=32767(big)
reg [3:0] bit_index = 0;  //keep track of current bit (0 to 9)
                          //width 4bits | max value(2^n-1)=upto 15 
reg [10:0] uart_frame = 11'b11111111111;  //UART frame: start+data+stop
                                          //initializing with 1 to avoid unknown(X) values at start.
reg sending = 0;  //Transmission state(0 => ideal)
reg [23:0] led_counter = 0;// keep LED on for some time 

wire parity_bit;
assign parity_bit = ^data_in;      //even parity

always @(posedge clk)
begin
    if (!sending && start)
    begin
        uart_frame <= {1'b1, parity_bit, data_in, 1'b0};  //stop + parity bit + data + start
        clk_count <= 0;
        bit_index <= 0;
        sending <= 1;
        tx_busy <= 1;
        tx_done <= 0;
    end
    else if (sending)    //we are currently in the middle of sending bits
    begin
        if (clk_count == CLKS_PER_BIT - 1)
        begin
            clk_count <= 0;
            tx <= uart_frame[bit_index];
            bit_index <= bit_index + 1;  //go to next bit for next cycle

            if (bit_index == 10)    //if we just send the 11th bit
            begin
                sending <= 0;
                tx_busy <= 0;
                tx_done <= 1;
                led_counter <= 24'd5_000_000;  //LED stay on for 50ms
            end
        end
        else 
        begin
            clk_count <= clk_count + 1;
        end
    end
    else           //ideal state
    begin
        tx <= 1;         //ideal line high
        tx_done <= 0;    //clear done signal
    end

    if (led_counter > 0)       //LED blink logic
    begin
        led <= 1;
        led_counter <= led_counter - 1;
    end
    else 
    begin
        led <= 0;
    end
end

endmodule

