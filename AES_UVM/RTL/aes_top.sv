// Code your design here
`ifdef DECIPHER
`include "AES_DECIPHER.sv"
`else
`include "AES_CIPHER.sv"
`endif
module aes_top(
    input logic [127:0] data_in,
    input logic [127:0] key,
    input logic clk,
    input logic rst_n,

    output logic [127:0] data_out,
    output logic finished
);

    `ifdef DECIPHER
        AES_DECIPHER u_decipher_top (
            .clk(clk),
            .rst_n(rst_n),
            .cipher_text(data_in),
            .round_key_10(key),
            .plain_text(data_out),
            .decipher_ready(finished)
        );
    `else
        AES_CIPHER u_cipher_top(
            .clk(clk),
            .rst_n(rst_n),
            .plain_text(data_in),
            .cipher_key(key),
            .cipher_text(data_out),
            .cipher_ready(finished)
        );
    `endif 
   
  
endmodule
