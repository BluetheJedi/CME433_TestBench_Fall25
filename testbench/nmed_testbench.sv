`timescale 1ns/1ps

module nmed_testbench
;

logic signed [7:0] x;
logic signed [7:0] y;
logic signed [15:0] prod_hlr;
logic signed [15:0] prod_exact;

real diff_sum;

logic signed [15:0] diff;

real mean = 0.1;


logic signed [15:0] max_exact;

integer count = 0;


exact_mult e_mult (
    .i_a(x),
    .i_b(y),
    .o_z(prod_exact)
);

hlr_bm2_mod bm2_mult (
    .x(x),
    .y(y),
    .prod(prod_hlr)
);


initial begin
    x <= 0;
    y <= 0;
    max_exact <=0;
    diff_sum <= 0;

    #1;

    for (int i = 0; i < 256; i++) begin
        for (int j = 0; j < 256; j++) begin
            x <= i;
            y <= j;
            count <= count + 1;


            #1;
            if (prod_exact > max_exact) max_exact <= prod_exact;


            diff <= prod_hlr - prod_exact;

            #1;
            // #1;

            if (diff < 0) diff <= prod_exact - prod_hlr;

            #1;
            // #1;


            diff_sum <= (diff_sum + diff);


        end
    end

    #1;


    mean <= diff_sum/count;
    #1;

    $display("-------------------------------------------------------------------");
    $display("NMED over all possible 8-bit values: %e", mean/max_exact);
    $display("-------------------------------------------------------------------");
    #1;
    $finish;
end

endmodule
