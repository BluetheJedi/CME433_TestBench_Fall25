module hlr_bm1_mod(
    input  signed [7:0] x,   // multiplier
    input  signed [7:0] y,   // multiplicand
    output signed [15:0] prod
);


    wire signed [8:0] x_with_zero = {x, 1'b0};


    wire [3:0] grp0 = x_with_zero[3:0]; // r8abe2 (approximate radix-8)
    wire [3:0] grp1 = x_with_zero[6:3]; //r8abe2 (approximate radix-8)
    wire [2:0] grp2 = x_with_zero[8:6]; //r4 (exact radix-4)


    function signed [15:0] r4_booth_encoder(
        input [2:0] g, //Current group
        input signed [7:0] m //Multiplicand
    );
        reg signed [15:0] result;
        begin
            case (g)
                3'b000, 3'b111: result = 16'sd0;  // 0
                3'b001, 3'b010: result = $signed({{8{m[7]}}, m});        // +1m
                3'b011:         result = $signed({{7{m[7]}}, m, 1'b0});  // +2m
                3'b100:         result = -$signed({{7{m[7]}}, m, 1'b0}); // -2m
                3'b101, 3'b110: result = -$signed({{8{m[7]}}, m});       // -1m
                default:        result = 16'sd0;
            endcase
            r4_booth_encoder = result;
        end
    endfunction



    function signed [15:0] r8abe2_encoder(
        input [3:0] g, //Current group
        input signed [7:0] m //Multiplicand
    );
        reg signed [15:0] result;
        begin
            case (g)
                //exact cases
                4'b0000, 4'b1111: result = 16'sd0;
                4'b0001, 4'b0010: result = $signed({{8{m[7]}}, m});        // +1C
                4'b0011, 4'b0100: result = $signed({{7{m[7]}}, m, 1'b0});  // +2C
                4'b0111:         result = $signed({{6{m[7]}}, m, 2'b00});  // +4C
                4'b1000:         result = -$signed({{6{m[7]}}, m, 2'b00}); // -4C
                4'b1100, 4'b1011: result = -$signed({{7{m[7]}}, m, 1'b0}); // -2C
                4'b1110, 4'b1101: result = -$signed({{8{m[7]}}, m});       // -1C

                //R8ABE2 approx for +/- 3C omissions
                4'b0101, 4'b0110: result = $signed({{7{m[7]}}, m, 1'b0});  // +3 -> +2
                4'b1010, 4'b1001: result = -$signed({{7{m[7]}}, m, 1'b0}); // -3 -> -2

                default: result = 16'sd0;
            endcase
            r8abe2_encoder = result;
        end
    endfunction


    function automatic signed [16:0] approx_add_lsb_nocarry(
      input signed [16:0] a,
      input signed [16:0] b
      );
      reg        carry;
      reg [16:0] s;
      integer    i;
      begin
          s[3:0] = a[3:0] ^ b[3:0];

          carry = 1'b0;
          for (i = 4; i < 17; i = i + 1) begin
              s[i]   = a[i] ^ b[i] ^ carry;
              carry  = (a[i] & b[i]) | (a[i] & carry) | (b[i] & carry);
          end

          approx_add_lsb_nocarry = s;
      end
    endfunction



    wire signed [16:0] pp0 = r8abe2_encoder(grp0, y);
    wire signed [16:0] pp1 = r8abe2_encoder(grp1, y) << 3;
    wire signed [16:0] pp2 = r4_booth_encoder(grp2, y) << 6;


    wire signed [16:0] sum_tmp = approx_add_lsb_nocarry(pp0, pp1);

    wire signed [16:0] sum_pp = approx_add_lsb_nocarry(sum_tmp, pp2);

    assign prod = sum_pp[15:0];


endmodule
