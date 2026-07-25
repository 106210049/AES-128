`include "mixCol.sv"
module MixColumns(
  input logic [127:0] mixColumn_in,
  output logic [127:0] after_mixColumns
);
  logic [127:0] after_mixColumn;
  mixCol mix_col1(.mixColumn_in(mixColumn_in[127:96]),.after_mixColumn(after_mixColumn[127:96]));
  mixCol mix_col2(.mixColumn_in(mixColumn_in[95:64]),.after_mixColumn(after_mixColumn[95:64]));
  mixCol mix_col3(.mixColumn_in(mixColumn_in[63:32]),.after_mixColumn(after_mixColumn[63:32]));
  mixCol mix_col4(.mixColumn_in(mixColumn_in[31:0]),.after_mixColumn(after_mixColumn[31:0]));
  assign after_mixColumns=after_mixColumn;
endmodule
