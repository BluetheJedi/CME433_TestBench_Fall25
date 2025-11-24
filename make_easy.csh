#!/bin/csh

#set design_name = "modified_booth_bm2"

cd design_compiler && source ./run_dc_analysis.csh $1 ../src/

cd ../sim && source ./run_tb.sh $1 && source ./run_tb_nmed.sh

cd ../python && python3 get_mnist_stats.py $1

echo "Make me easy done!"