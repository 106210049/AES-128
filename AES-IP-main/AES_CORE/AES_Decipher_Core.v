`include "AES_Decipher_Controller.v"
// `include "AddRoundKey.v"
`include "InvSubBytes.v"
`include "InvShiftRows.v"
`include "InvMixColumns_top.v"

module AES_decipher_core(
   input wire clk,
   input wire rst_n,
   input wire [127:0] cipher_text,
   input wire [127:0] round_key_10,
   input wire [127:0] round_key_inv,
   
   output wire begin_round,
   output wire rkey_en,  
   output wire decipher_ready,
   output wire [127:0] plain_text,
   output wire [3:0] round_num
);

  wire first_time_en, decipher_complete;
  wire [127:0] key_in, addRoundKey_in, after_addRoundKey;
  wire [127:0] invShiftRows_in, after_invShiftRows, after_inv_mixColumns;
  wire [127:0] after_invSubBytes;
  reg [127:0] plain_text_reg;
  reg [127:0] after_inv_mixColumns_reg;
  
  // reg [3:0] round_num_tmp;
  // wire [3:0] round_num_reg;
  
  // assign round_num_reg=round_num;
  AES_decipher_controller aes_decipher_controller (
    .clk(clk),
    .rst_n(rst_n),

    .round_num(round_num),
    .decipher_ready(decipher_ready),
    .begin_round(begin_round),
    .rkey_en(rkey_en),
    .first_time_en(first_time_en)
  );
  
  wire [127:0] inv_Shiftrows_byte;
  assign key_in = (begin_round) ? round_key_10 : round_key_inv;
  assign addRoundKey_in = (begin_round) ? cipher_text : after_invSubBytes;
  
  AddRoundKey add_round_key (
    .addRoundKey_in(addRoundKey_in),
    .round_key(key_in),
    .after_addRoundKey(after_addRoundKey)
  );
  
  assign inv_Shiftrows_byte = (first_time_en) ? plain_text_reg : after_inv_mixColumns_reg;
  
  assign invShiftRows_in[127:120] = inv_Shiftrows_byte[127:120];
  assign invShiftRows_in[119:112] = inv_Shiftrows_byte[95:88];
  assign invShiftRows_in[111:104] = inv_Shiftrows_byte[63:56];
  assign invShiftRows_in[103:96]  = inv_Shiftrows_byte[31:24];

  assign invShiftRows_in[95:88]   = inv_Shiftrows_byte[119:112];
  assign invShiftRows_in[87:80]   = inv_Shiftrows_byte[87:80];
  assign invShiftRows_in[79:72]   = inv_Shiftrows_byte[55:48];
  assign invShiftRows_in[71:64]   = inv_Shiftrows_byte[23:16];

  assign invShiftRows_in[63:56]   = inv_Shiftrows_byte[111:104];
  assign invShiftRows_in[55:48]   = inv_Shiftrows_byte[79:72];
  assign invShiftRows_in[47:40]   = inv_Shiftrows_byte[47:40];
  assign invShiftRows_in[39:32]   = inv_Shiftrows_byte[15:8];

  assign invShiftRows_in[31:24]   = inv_Shiftrows_byte[103:96];
  assign invShiftRows_in[23:16]   = inv_Shiftrows_byte[71:64];
  assign invShiftRows_in[15:8]    = inv_Shiftrows_byte[39:32];
  assign invShiftRows_in[7:0]     = inv_Shiftrows_byte[7:0];
  
  InvShiftRows inv_shift_rows (
    .invShiftRows_in(invShiftRows_in),
    .after_invShiftRows(after_invShiftRows)
  );

  wire [127:0] inv_SubBytes_transposed;
  assign inv_SubBytes_transposed[127:120] = after_invShiftRows[127:120];
  assign inv_SubBytes_transposed[119:112] = after_invShiftRows[95:88];
  assign inv_SubBytes_transposed[111:104] = after_invShiftRows[63:56];
  assign inv_SubBytes_transposed[103:96]  = after_invShiftRows[31:24];
  assign inv_SubBytes_transposed[95:88]   = after_invShiftRows[119:112];
  assign inv_SubBytes_transposed[87:80]   = after_invShiftRows[87:80];
  assign inv_SubBytes_transposed[79:72]   = after_invShiftRows[55:48];
  assign inv_SubBytes_transposed[71:64]   = after_invShiftRows[23:16];
  assign inv_SubBytes_transposed[63:56]   = after_invShiftRows[111:104];
  assign inv_SubBytes_transposed[55:48]   = after_invShiftRows[79:72];
  assign inv_SubBytes_transposed[47:40]   = after_invShiftRows[47:40];
  assign inv_SubBytes_transposed[39:32]   = after_invShiftRows[15:8];
  assign inv_SubBytes_transposed[31:24]   = after_invShiftRows[103:96];
  assign inv_SubBytes_transposed[23:16]   = after_invShiftRows[71:64];
  assign inv_SubBytes_transposed[15:8]    = after_invShiftRows[39:32];
  assign inv_SubBytes_transposed[7:0]     = after_invShiftRows[7:0];

  InvSubBytes inv_sub_bytes (
    .inv_SubBytes_in(inv_SubBytes_transposed),
    .after_invSubBytes(after_invSubBytes)
  );
  
  InvMixColumns_top inv_mix_columns (
    .inv_mixColumns_in(after_addRoundKey),
    .after_inv_mixColumns(after_inv_mixColumns)
  );

  
  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        after_inv_mixColumns_reg <= 128'h0;
    end
    else  begin
        after_inv_mixColumns_reg <= after_inv_mixColumns;
    end
  end
  always@(posedge clk or negedge rst_n)	begin
    if(!rst_n)	begin
      plain_text_reg<=128'h0;
    end
    else if(rkey_en!=begin_round)	begin
      plain_text_reg<=after_addRoundKey;
    end
    else	begin
      plain_text_reg<=plain_text_reg;
    end
  end
  
  assign plain_text = (decipher_ready) ? plain_text_reg : 128'h0;
  
endmodule
