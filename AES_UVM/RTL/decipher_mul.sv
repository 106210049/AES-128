`include "mul2.sv"
module decipher_mul(
  input logic [7:0] inv_mixColumns_in,
  output logic [7:0] mul2_out,
  output logic [7:0] mul4_out,
  output logic [7:0] mul8_out
  
);
  mul2 out_mul2(.inv_mixColumns_in(inv_mixColumns_in),.mul2_out(mul2_out));
  mul2 out_mul4(.inv_mixColumns_in(mul2_out),.mul2_out(mul4_out));
  mul2 out_mul8(.inv_mixColumns_in(mul4_out),.mul2_out(mul8_out));
endmodule
