#!/bin/csh

cd sim && source ./run_tb.sh $1

cd ../python && python3 get_mnist_stats.py $1

echo "Make me easy done!"