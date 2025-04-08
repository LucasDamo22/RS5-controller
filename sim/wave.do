onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /testbench_RS5_controller/dut/Peripherals1/UART_TX_CTRL/i_Clock
add wave -noupdate /testbench_RS5_controller/dut/Peripherals1/UART_TX_CTRL/reset_n
add wave -noupdate /testbench_RS5_controller/dut/Peripherals1/UART_TX_CTRL/i_Tx_DV
add wave -noupdate /testbench_RS5_controller/dut/Peripherals1/UART_TX_CTRL/i_Tx_Byte
add wave -noupdate /testbench_RS5_controller/dut/Peripherals1/UART_TX_CTRL/o_Tx_Active
add wave -noupdate /testbench_RS5_controller/dut/Peripherals1/UART_TX_CTRL/o_Tx_Serial
add wave -noupdate /testbench_RS5_controller/dut/Peripherals1/ring_buf/clk_i
add wave -noupdate /testbench_RS5_controller/dut/Peripherals1/ring_buf/rst_ni
add wave -noupdate /testbench_RS5_controller/dut/Peripherals1/ring_buf/buf_rst_i
add wave -noupdate /testbench_RS5_controller/dut/Peripherals1/ring_buf/rx_i
add wave -noupdate /testbench_RS5_controller/dut/Peripherals1/ring_buf/rx_ack_o
add wave -noupdate /testbench_RS5_controller/dut/Peripherals1/ring_buf/data_i
add wave -noupdate /testbench_RS5_controller/dut/Peripherals1/ring_buf/tx_o
add wave -noupdate /testbench_RS5_controller/dut/Peripherals1/ring_buf/tx_ack_i
add wave -noupdate /testbench_RS5_controller/dut/Peripherals1/ring_buf/data_o
add wave -noupdate /testbench_RS5_controller/dut/Peripherals1/BUFFER_write
add wave -noupdate /testbench_RS5_controller/dut/Peripherals1/BUFFER_read
add wave -noupdate /testbench_RS5_controller/dut/Peripherals1/BUFFER_read_avail
add wave -noupdate /testbench_RS5_controller/dut/Peripherals1/BUFFER_read_avail_comb
add wave -noupdate /testbench_RS5_controller/dut/Peripherals1/BUFFER_write_avail
add wave -noupdate /testbench_RS5_controller/dut/Peripherals1/BUFFER_data
add wave -noupdate /testbench_RS5_controller/dut/Peripherals1/UART_TX_busy
add wave -noupdate /testbench_RS5_controller/dut/Peripherals1/UART_TX_data
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {499581 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 198
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {499519 ns} {500026 ns}
