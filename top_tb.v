module top_tb;
reg clk = 0;
reg start = 0;
  reg [7:0] data_in = 8'd0;
wire tx, rx;
wire [7:0] data_out;
wire tx_done, rx_done, parity_error;
wire led_tx, led_rx;
top DUT (
      .clk(clk),
      .start(start),
      .data_in(data_in),
      .tx(tx),
      .rx(rx),
      .data_out(data_out),
      .tx_done(tx_done),
      .rx_done(rx_done),
      .parity_error(parity_error),
      .led_tx(led_tx),
      .led_rx(led_rx)
);
always #10 clk = ~clk; // 100MHz clock

     initial begin
       start = 0;
       data_in = 8'd0;
       #100;
       //test case 1
       data_in = 8'd165;
       start = 1;
       #20;
       start = 0;
       #10000;
       //test case 2
       data_in = 8'd60;
       start = 1;
       #20;
       start = 0;
       #10000;
       $stop;
       end
endmodule
