`include "inv_mix_col.v"

module InvMixColumns_top (
  input wire [127:0] inv_mixColumns_in,
  output wire [127:0] after_inv_mixColumns
);
    wire [31:0] col15, col14, col13, col12;
    wire [31:0] after_col15, after_col14, after_col13, after_col12;

    assign {col15, col14, col13, col12} = inv_mixColumns_in;

  inv_mix_col mix_col15(.inv_mixColumns_in(col15), .after_inv_mixColumns(after_col15));
  inv_mix_col mix_col14(.inv_mixColumns_in(col14), .after_inv_mixColumns(after_col14));
  inv_mix_col mix_col13(.inv_mixColumns_in(col13), .after_inv_mixColumns(after_col13));
  inv_mix_col mix_col12(.inv_mixColumns_in(col12), .after_inv_mixColumns(after_col12));

    assign after_inv_mixColumns = {after_col15, after_col14, after_col13, after_col12};
endmodule
