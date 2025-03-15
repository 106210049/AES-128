// Code your design here
`include "AES_Cipher_Core.v"
`include "AES_Key_Expand.v"
module AES_Cipher(
  input wire clk,
  input wire rst_n,
  input wire [127:0] plain_text,
  input wire [127:0] cipher_key,
  
  output reg [127:0] cipher_text,
  output reg cipher_ready
);
  reg [127:0] round_key_out;
  reg begin_round, rkey_en;
  reg [3:0] round_num;
  
  Cipher_Core cipher_core (
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
  AES_Key_Expand aes_key_expand (
    .clk(clk),
    .rst_n(rst_n),
    .round_num(round_num),
    .cipher_key(cipher_key),
    .begin_round(begin_round),
    .rkey_en(rkey_en),
    .round_key_out(round_key_out)
  );
endmodule