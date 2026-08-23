// Code your design here
`include "AES_Cipher_Core.sv"
`include "AES_Key_Expand.sv"
module AES_CIPHER(
  input logic clk,
  input logic rst_n,
  input logic [127:0] plain_text,
  input logic [127:0] cipher_key,
  
  output logic [127:0] cipher_text,
  output logic cipher_ready
);
  logic [127:0] round_key_out;
  logic begin_round, rkey_en;
  logic [3:0] round_num;
  
  AES_Cipher_Core u_cipher_core (
    .clk(clk),
    .rst_n(rst_n),
    .plain_text(plain_text),
    .cipher_key(cipher_key),
    .round_key(round_key_out),
    .cipher_text(cipher_text),
    .begin_round(begin_round),
    .rkey_en(rkey_en),
    .round_num(round_num),
    .cipher_ready(cipher_ready)
  );
  AES_Key_Expand u_key_expand (
    .clk(clk),
    .rst_n(rst_n),
    .round_num(round_num),
    .cipher_key(cipher_key),
    .begin_round(begin_round),
    .rkey_en(rkey_en),
    .round_key_out(round_key_out)
  );
endmodule
