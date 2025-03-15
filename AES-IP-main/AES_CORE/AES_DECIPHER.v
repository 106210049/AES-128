// Code your design here
`include "AES_Inv_Key_Expand.v"
`include "AES_Decipher_Core.v"
module AES_Decipher(
  input wire clk,
  input wire rst_n,
  input wire [127:0] cipher_text,
  input wire [127:0] round_key_10,
  
  output wire decipher_ready,
  output wire [127:0] plain_text
  
);
  wire [3:0] round_num;
  wire rkey_en,begin_round;
  wire [127:0] round_key_out;
  AES_decipher_core aes_decipher_core (
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
  AES_Inv_Key_Expand aes_inv_key_expand (
    .clk(clk),
    .rst_n(rst_n),
    .round_key_10(round_key_10),
    .round_num(round_num),
    .rkey_en(rkey_en),
    .begin_round(begin_round),
    .round_key_out(round_key_out)
  );
endmodule