vlog ../rtl/cpu/aes/*.sv

vlog ../rtl/platform/*.sv
vlog ../rtl/cpu/*.sv
vlog testbench_RS5_controller.sv
vsim -voptargs=+acc work.testbench_RS5_controller
do wave.do
run 500us
