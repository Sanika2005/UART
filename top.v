module top(
    input wire clk,             // 100 MHz clock,           
    output wire tx,             // UART transmission line
    input wire rx,              // UART reception line
    output wire tx_led,         // LED for transmission
    output wire rx_led       // LED for reception
    );
    wire [7:0] data_out; 
    wire parity_error;
    wire tx_busy;
    wire tx_done;
    wire rx_done;
    wire start;
    wire [7:0] data_in;
    uart_transmitter i1 (
        .clk(clk),
        .start(start),
        .data_in(data_in),
        .tx(tx),
        .tx_busy(tx_busy),
        .tx_done(tx_done),
        .led(tx_led)
    );

    uart_receiver i2 (
        .clk(clk),
        .rx(rx),
        .data_out(data_out),
        .rx_done(rx_done),
        .parity_error(parity_error),
        .led(rx_led)
    );
     ila_0 i3 (
	.clk(clk), // input wire clk


	.probe0(tx), // input wire [0:0]  probe0  
	.probe1(tx_busy), // input wire [0:0]  probe1 
	.probe2(tx_done), // input wire [0:0]  probe2 
	.probe3(rx), // input wire [0:0]  probe3 
	.probe4(rx_done), // input wire [0:0]  probe4 
	.probe5(data_out), // input wire [7:0]  probe5 
	.probe6(parity_error), // input wire [0:0]  probe6 
	.probe7(led_tx), // input wire [0:0]  probe7 
	.probe8(led_rx) // input wire [0:0]  probe8
);
vio_0 i4 (
  .clk(clk),                // input wire clk
  .probe_out0(start),  // output wire [0 : 0] probe_out0
  .probe_out1(data_in)  // output wire [7 : 0] probe_out1
);

    
endmodule
