`include "mixCol.v"
module mixColumns(
  input wire [127:0] mixColumn_in,
  output wire [127:0] after_mixColumns
);
  wire [127:0] after_mixColumn;
  mix_col mix_col1(.mixColumn_in(mixColumn_in[127:96]),.after_mixColumn(after_mixColumn[127:96]));
  mix_col mix_col2(.mixColumn_in(mixColumn_in[95:64]),.after_mixColumn(after_mixColumn[95:64]));
  mix_col mix_col3(.mixColumn_in(mixColumn_in[63:32]),.after_mixColumn(after_mixColumn[63:32]));
  mix_col mix_col4(.mixColumn_in(mixColumn_in[31:0]),.after_mixColumn(after_mixColumn[31:0]));
  assign after_mixColumns=after_mixColumn;
endmodule