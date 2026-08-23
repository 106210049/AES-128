// Code your design here
`include "AES_Inv_Key_Expand.sv"
`include "AES_Decipher_Core.sv"
module AES_DECIPHER(
  input logic clk,
  input logic rst_n,
  input logic [127:0] cipher_text,
  input logic [127:0] round_key_10,
  
  output logic decipher_ready,
  output logic [127:0] plain_text
);
  logic [3:0] round_num;
  logic rkey_en,begin_round;
  logic [127:0] round_key_out;
  AES_Decipher_Core u_decipher_core (
    .clk(clk),
    .rst_n(rst_n),
    .cipher_text(cipher_text),
    .round_key_10(round_key_10),
    .round_key_inv(round_key_out),
    
    .begin_round(begin_round),
    .plain_text(plain_text),
    .rkey_en(rkey_en),
    .round_num(round_num),
    .decipher_ready(decipher_ready)
  );
  AES_Inv_Key_Expand u_inv_key_expand (
    .clk(clk),
    .rst_n(rst_n),
    .round_key_10(round_key_10),
    .round_num(round_num),
    .rkey_en(rkey_en),
    .begin_round(begin_round),
    .round_key_out(round_key_out)
  );
endmodule
