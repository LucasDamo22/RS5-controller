onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -expand -group master_signals /tb_i2c_generic/dut/sda_tristate_en_o
add wave -noupdate -expand -group master_signals /tb_i2c_generic/dut/current_state
add wave -noupdate -expand -group master_signals /tb_i2c_generic/dut/scl_o
add wave -noupdate /tb_i2c_generic/sda_line
add wave -noupdate /tb_i2c_generic/dut_bno/current_state
add wave -noupdate /tb_i2c_generic/dut_bno/reg_addr
add wave -noupdate /tb_i2c_generic/dut_bno/reg_data
add wave -noupdate /tb_i2c_generic/dut_bno/bno_data_o
add wave -noupdate /tb_i2c_generic/dut_bno/regs/BNO055_OPR_MODE_reg
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {65767 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 198
configure wave -valuecolwidth 56
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
WaveRestoreZoom {0 ns} {249840 ns}
