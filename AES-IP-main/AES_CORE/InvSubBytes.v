`include "aes_inv_Sbox.v"
module InvSubBytes(
  input  wire [127:0] inv_SubBytes_in,      // Input 16 byte (renamed)
  output wire [127:0] after_invSubBytes     // Output 16 byte sau Inverse SubByte
);
  aes_inv_Sbox inv_sbox1(.sbox_in(inv_SubBytes_in[127:120]), .aes128_inv_sbox(after_invSubBytes[127:120]));
  aes_inv_Sbox inv_sbox2(.sbox_in(inv_SubBytes_in[119:112]), .aes128_inv_sbox(after_invSubBytes[119:112]));
  aes_inv_Sbox inv_sbox3(.sbox_in(inv_SubBytes_in[111:104]), .aes128_inv_sbox(after_invSubBytes[111:104]));
  aes_inv_Sbox inv_sbox4(.sbox_in(inv_SubBytes_in[103:96]),  .aes128_inv_sbox(after_invSubBytes[103:96]));
  aes_inv_Sbox inv_sbox5(.sbox_in(inv_SubBytes_in[95:88]),   .aes128_inv_sbox(after_invSubBytes[95:88]));
  aes_inv_Sbox inv_sbox6(.sbox_in(inv_SubBytes_in[87:80]),   .aes128_inv_sbox(after_invSubBytes[87:80]));
  aes_inv_Sbox inv_sbox7(.sbox_in(inv_SubBytes_in[79:72]),   .aes128_inv_sbox(after_invSubBytes[79:72]));
  aes_inv_Sbox inv_sbox8(.sbox_in(inv_SubBytes_in[71:64]),   .aes128_inv_sbox(after_invSubBytes[71:64]));
  aes_inv_Sbox inv_sbox9(.sbox_in(inv_SubBytes_in[63:56]),   .aes128_inv_sbox(after_invSubBytes[63:56]));
  aes_inv_Sbox inv_sbox10(.sbox_in(inv_SubBytes_in[55:48]),  .aes128_inv_sbox(after_invSubBytes[55:48]));
  aes_inv_Sbox inv_sbox11(.sbox_in(inv_SubBytes_in[47:40]),  .aes128_inv_sbox(after_invSubBytes[47:40]));
  aes_inv_Sbox inv_sbox12(.sbox_in(inv_SubBytes_in[39:32]),  .aes128_inv_sbox(after_invSubBytes[39:32]));
  aes_inv_Sbox inv_sbox13(.sbox_in(inv_SubBytes_in[31:24]),  .aes128_inv_sbox(after_invSubBytes[31:24]));
  aes_inv_Sbox inv_sbox14(.sbox_in(inv_SubBytes_in[23:16]),  .aes128_inv_sbox(after_invSubBytes[23:16]));
  aes_inv_Sbox inv_sbox15(.sbox_in(inv_SubBytes_in[15:8]),   .aes128_inv_sbox(after_invSubBytes[15:8]));
  aes_inv_Sbox inv_sbox16(.sbox_in(inv_SubBytes_in[7:0]),    .aes128_inv_sbox(after_invSubBytes[7:0]));

endmodule