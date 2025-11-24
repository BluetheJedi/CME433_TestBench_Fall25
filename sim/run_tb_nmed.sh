source ./compile_designs.sh

#vopt -work work nmed_testbench -o nmed_testbench$1_opt

vsim -c nmed_testbench -do "run -all"
