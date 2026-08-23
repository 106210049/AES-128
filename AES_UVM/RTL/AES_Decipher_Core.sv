`include "AES_Decipher_Controller.sv"
`include "AddRoundKey.sv"
`include "InvSubBytes.sv"
`include "InvShiftRows.sv"
`include "InvMixColumns.sv"

module AES_Decipher_Core(
   input logic clk,
   input logic rst_n,
   input logic [127:0] cipher_text,
   input logic [127:0] round_key_10,
   input logic [127:0] round_key_inv,
   
   output logic begin_round,
   output logic rkey_en,  
   output logic decipher_ready,
   output logic [127:0] plain_text,
   output logic [3:0] round_num
);

  logic first_time_en;
  logic [127:0] key_in, addRoundKey_in, after_addRoundKey;
  logic [127:0] invShiftRows_in, after_invShiftRows, after_inv_mixColumns;
  logic [127:0] after_invSubBytes;
  logic [127:0] plain_text_reg;
  logic [127:0] after_inv_mixColumns_reg;
  
  // reg [3:0] round_num_tmp;
  // logic [3:0] round_num_reg;
  
  // assign round_num_reg=round_num;
  AES_Decipher_Controller aes_decipher_controller (
    .clk(clk),
    .rst_n(rst_n),

    .round_num(round_num),
    .decipher_ready(decipher_ready),
    .begin_round(begin_round),
    .rkey_en(rkey_en),
    .first_time_en(first_time_en)
  );
  
  logic [127:0] invShiftrows_in;
  assign key_in = (begin_round) ? round_key_10 : round_key_inv;
  assign addRoundKey_in = (begin_round) ? cipher_text : after_invSubBytes;
  
  AddRoundKey u_add_round_key (
    .addRoundKey_in(addRoundKey_in),
    .round_key(key_in),
    .after_addRoundKey(after_addRoundKey)
  );
  
  assign invShiftrows_in = (first_time_en) ? plain_text_reg : after_inv_mixColumns_reg;
  
  
  InvShiftRows u_inv_shift_rows (
    .invShiftRows_in(invShiftrows_in),
    .after_invShiftRows(after_invShiftRows)
  );

  InvSubBytes u_inv_sub_bytes (
    .inv_SubBytes_in(after_invShiftRows),
    .after_invSubBytes(after_invSubBytes)
  );
  
  InvMixColumns u_inv_mix_columns (
    .inv_mixColumns_in(after_addRoundKey),
    .after_inv_mixColumns(after_inv_mixColumns)
  );

  
  always_ff@(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        after_inv_mixColumns_reg <= 128'h0;
    end
    else  begin
        after_inv_mixColumns_reg <= after_inv_mixColumns;
    end
  end
  always_ff@(posedge clk or negedge rst_n)	begin
    if(!rst_n)	begin
      plain_text_reg<=128'h0;
    end
    else if(rkey_en ^ begin_round)	begin
      plain_text_reg<=after_addRoundKey;
    end
    else	begin
      plain_text_reg<=plain_text_reg;
    end
  end
  
  assign plain_text = (decipher_ready) ? plain_text_reg : 128'h0;
  
endmodule
