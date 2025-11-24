import gzip
import sys
import numpy as np


def twoscomp_to_decimal(inarray, bits_in_word):
    inputs = []
    for bin_input in inarray:
        if bin_input[0] == "0":
            inputs.append(int(bin_input, 2))
        else:
            inputs.append(int(bin_input, 2) - (1 << bits_in_word))
    
    inputs = np.array(inputs)
    return inputs


test_y = None
with open("../data/t10k-labels-idx1-ubyte.gz", "rb") as f:
    data = f.read()
    test_y = np.frombuffer(gzip.decompress(data), dtype=np.uint8).copy()

test_y = test_y[8:]


# print(sys.argv)

SVERILOG_BATCH_COUNT = 100
SVERILOG_BATCH_SIZE = 1
ROOT_DIR = "../results/"
SVERILOG_FINAL_LAYER = 2
VERSION = sys.argv[1]
MAX_MULT_OUTPUT = 2**16 - 1

acc = 0


error = []
exact_outputs = []
for i in range(0, SVERILOG_BATCH_COUNT):    
    predictions_bin_approx = []
    with open(
        ROOT_DIR
        + "mult{}_{}in_layer{}_out.txt".format(VERSION, i, SVERILOG_FINAL_LAYER)
    ) as pfile:
        predictions_bin_approx = pfile.readlines()

    predictions_approx = twoscomp_to_decimal(predictions_bin_approx, 8)
    
    if predictions_approx.argmax() == test_y[i]:
        acc += 1

    
    

for layer in range(0, SVERILOG_FINAL_LAYER+1):
    for i in range(0, SVERILOG_BATCH_COUNT):
        
        
        predictions_bin_approx = []
        with open(
            ROOT_DIR
            + "mult{}_{}in_layer{}_out.txt".format(VERSION, i, layer)
        ) as pfile:
            predictions_bin_approx = pfile.readlines()

        predictions_approx = twoscomp_to_decimal(predictions_bin_approx, 8)
        
        # print("predictions_approx:", predictions_approx)
        # print("argmax:", predictions_approx.argmax())
        # print("Max value:", np.max(predictions_approx))
        
        predictions_bin_exact = []
        with open(
            ROOT_DIR
            + "mult{}_{}in_layer{}_out.txt".format("exact", i, layer)
        ) as pfile_exact:
            predictions_bin_exact = pfile_exact.readlines()

        predictions_exact = twoscomp_to_decimal(predictions_bin_exact, 8)

        curr_mac = 0
        curr_exact = 0
        for j in range(len(predictions_approx)):
            curr_mac += (predictions_approx[j] - predictions_exact[j])
            curr_exact += predictions_exact[j]
            
        error.append((curr_mac))
        exact_outputs.append(curr_exact)
        

    print("For Layer:", layer)

    nmed = np.mean(np.array(np.abs(error))) / np.max(np.array(exact_outputs))
    print(f"NMED: {nmed:e}")



print("Acc: ", acc * 100 / SVERILOG_BATCH_COUNT)