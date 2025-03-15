// Code your design here
`include "AES_CIPHER.v"
`include "AES_DECIPHER.v"
`include "AES_Config_Parameter.v" // Define function of IP here
module AES_CORE(
    input wire [127:0] data_in,
    input wire [127:0] key,
    input wire clk,
    input wire rst_n,

    output wire [127:0] data_out,
    output wire finished
);
    wire [127:0] plain_text, cipher_text, cipher_key, round_key_10;
    wire [127:0] plain_text_out,cipher_text_out;
    wire cipher_ready, decipher_ready;
    wire cipher_clk, decipher_clk, cipher_rst_n, decipher_rst_n;
    `ifdef CIPHER
        assign plain_text=data_in;
        assign cipher_key=key;
        assign data_out=cipher_text_out;
        assign finished=cipher_ready;
        assign cipher_clk=clk;
        assign cipher_rst_n=rst_n;
    `else
        assign cipher_text=data_in;
        assign round_key_10=key;
        assign data_out=plain_text_out;
        assign finished=decipher_ready;
        assign decipher_clk=clk;
        assign decipher_rst_n=rst_n;
    `endif 
    AES_Cipher aes_cipher_top(
    .clk(cipher_clk),
    .rst_n(cipher_rst_n),
    .plain_text(plain_text),
    .cipher_key(cipher_key),
    .cipher_text(cipher_text_out),
    .cipher_ready(cipher_ready)
  );
  AES_Decipher aes_decipher_top (
    .clk(decipher_clk),
    .rst_n(decipher_rst_n),
    .cipher_text(cipher_text),
    .round_key_10(round_key_10),
    
    .plain_text(plain_text_out),
    .decipher_ready(decipher_ready)
  );
endmodule