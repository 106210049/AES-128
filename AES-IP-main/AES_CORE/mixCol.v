`include "mul.v"
module mix_col(
  input wire [31:0] mixColumn_in,
  output wire [31:0] after_mixColumn
);
  wire [7:0] byte15_mul2,byte15_mul3;
  wire [7:0] byte14_mul2,byte14_mul3;
  wire [7:0] byte13_mul2,byte13_mul3;
  wire [7:0] byte12_mul2,byte12_mul3;
  mul mul1(.mul_in(mixColumn_in[31:24]),.mul2_out(byte15_mul2),.mul3_out(byte15_mul3));
  mul mul2(.mul_in(mixColumn_in[23:16]),.mul2_out(byte14_mul2),.mul3_out(byte14_mul3));
  mul mul3(.mul_in(mixColumn_in[15:8]),.mul2_out(byte13_mul2),.mul3_out(byte13_mul3));
  mul mul4(.mul_in(mixColumn_in[7:0]),.mul2_out(byte12_mul2),.mul3_out(byte12_mul3));
  
  assign after_mixColumn[31:24]= byte15_mul2 ^ byte14_mul3 ^ mixColumn_in[15:8] ^ mixColumn_in[7:0];
  assign after_mixColumn[23:16]= mixColumn_in[31:24] ^ byte14_mul2 ^ byte13_mul3 ^ mixColumn_in[7:0];
  assign after_mixColumn[15:8]= mixColumn_in[31:24] ^ mixColumn_in[23:16] ^ byte13_mul2 ^ byte12_mul3;
  assign after_mixColumn[7:0]= byte15_mul3 ^ mixColumn_in[23:16] ^ mixColumn_in[15:8] ^ byte12_mul2;
  
endmodule