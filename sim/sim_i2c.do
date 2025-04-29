#vlog ../rtl/cpu/aes/*.sv

vlog -work work -sv ../rtl/platform/i2c_generic.sv
vlog -work work -sv ../rtl/platform/i2c_bno055_emulator_pkg.sv
vlog -work work -sv ../rtl/platform/i2c_bno055_emulator_regs.sv
vlog -work work -sv ../rtl/platform/i2c_bno055_emulator.sv
#vlog ../rtl/platform/i2c_generic.sv
#vlog ../rtl/cpu/*.sv
vlog -work work -sv tb_i2c_generic.sv
vsim -voptargs=+acc work.tb_i2c_generic
do wave.do
run 500us
