# Literature Review TB for CME 433 Fall 2025 (Group 5)

# Recreating our results

### For the hlr_bm2(Replication of provided literature):
    - Open the testbench/ folder and the nmed_testbench.sv file
    - Set line 29 of the nmed_testbench.sv file to be "hlr_bm2 bm2_mult ("
    - Open the src/ folder, and then the mult16via8.sv file
    - Change both of the multiplier instantiations to "hlr_bm2", instantiating the multiplier in hlr_bm2.sv
    - Open up a terminal in the main project folder, and run "./make_easy.csh hlr_bm2"

### For the modified approximate multiplier (hlr_bm2_modified):
    - Open the testbench/ folder and the nmed_testbench.sv file
    - Set line 29 of the nmed_testbench.sv file to be "hlr_bm2_mod mod_mult ("
    - Open the src/ folder, and then the mult16via8.sv file
    - Change both of the multiplier instantiations to "hlr_bm2_mod", instantiating the multiplier in hlr_bm2_mod.sv
    - Open up a terminal in the main project folder, and run "./make_easy.csh hlr_bm2_mod"

### For the modified approximate multiplier (hlr_bm1_modified):
    - Open the testbench/ folder and the nmed_testbench.sv file
    - Set line 29 of the nmed_testbench.sv file to be "hlr_bm1_mod mod_mult ("
    - Open the src/ folder, and then the mult16via8.sv file
    - Change both of the multiplier instantiations to "hlr_bm1_mod", instantiating the multiplier in hlr_bm2_mod.sv
    - Open up a terminal in the main project folder, and run "./make_easy.csh hlr_bm1_mod"

### To get the exact_mult stats:
    - Steps match initially provided steps
