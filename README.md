# UART Transmitter & Receiver on FPGA using VIO and ILA

## 📌 Project Overview

This project implements a simple **UART Transmitter and Receiver** on FPGA, tested through **ILA (Integrated Logic Analyzer)** and controlled via **VIO (Virtual Input/Output)** in hardware. It also supports simulation through a separate testbench.

- **Baud Rate:** 9600
- **Clock Frequency:** 100 MHz
- **Data Size:** 8-bit with Even Parity
- **FPGA Tool:** Xilinx Vivado
- **Target Device:** Any 7-series FPGA (e.g., Basys 3, Nexys A7)

---


---

## ⚙️ Functionality

### UART Transmitter (`uart_transmitter.v`)
- Inputs: `clk`, `start`, `data_in`
- Outputs: `tx`, `tx_busy`, `tx_done`, `led`

### UART Receiver (`uart_receiver.v`)
- Inputs: `clk`, `rx`
- Outputs: `data_out`, `rx_done`, `parity_error`, `led`

---

## 🧪 Simulation (Vivado Simulation)

To simulate:

1. Use the `top_tb_sim.v` file as the top module.
2. Testbench (`top_tb.v`) drives:
   - `start`
   - `data_in`
3. Monitors:
   - `tx_done`, `rx_done`, `parity_error`, `data_out`

### ✅ Note:
This version does **not** include ILA or VIO, so the `start` and `data_in` ports are manually driven in the testbench.

---

## 💡 FPGA Hardware Setup

Use `top.v` as the top module.

- Connect `tx` and `rx` pins via jumper wire (loopback) or use two FPGAs.
- Control `start` and `data_in` via VIO.
- Observe internal signals using ILA.

### VIO Outputs:
- `start` → `uart_transmitter`
- `data_in` → 8-bit data input

### ILA Inputs (Probes):
- `tx`
- `tx_busy`
- `tx_done`
- `rx`
- `rx_done`
- `data_out`
- `parity_error`
- `tx_led`
- `rx_led`

---

## 🔌 Constraints

Ensure your `.xdc` file has correct assignments like:

```xdc
set_property PACKAGE_PIN W5 [get_ports clk]
set_property PACKAGE_PIN U19 [get_ports rx]
set_property PACKAGE_PIN V20 [get_ports tx]
set_property PACKAGE_PIN U16 [get_ports tx_led]
set_property PACKAGE_PIN V17 [get_ports rx_led]



