// SubByte
`include "aes_Sbox.sv"

module SubBytes(
  input logic [127:0] subBytes_in, 
  output logic [127:0] after_subBytes 
);
  aes_Sbox aes_sbox1(.sbox_in(subBytes_in[127:120]), .aes128_sbox(after_subBytes[127:120]));
  aes_Sbox aes_sbox2(.sbox_in(subBytes_in[119:112]), .aes128_sbox(after_subBytes[119:112]));
  aes_Sbox aes_sbox3(.sbox_in(subBytes_in[111:104]), .aes128_sbox(after_subBytes[111:104]));
  aes_Sbox aes_sbox4(.sbox_in(subBytes_in[103:96]),  .aes128_sbox(after_subBytes[103:96]));
  aes_Sbox aes_sbox5(.sbox_in(subBytes_in[95:88]),   .aes128_sbox(after_subBytes[95:88]));
  aes_Sbox aes_sbox6(.sbox_in(subBytes_in[87:80]),   .aes128_sbox(after_subBytes[87:80]));
  aes_Sbox aes_sbox7(.sbox_in(subBytes_in[79:72]),   .aes128_sbox(after_subBytes[79:72]));
  aes_Sbox aes_sbox8(.sbox_in(subBytes_in[71:64]),   .aes128_sbox(after_subBytes[71:64]));
  aes_Sbox aes_sbox9(.sbox_in(subBytes_in[63:56]),   .aes128_sbox(after_subBytes[63:56]));
  aes_Sbox aes_sbox10(.sbox_in(subBytes_in[55:48]),  .aes128_sbox(after_subBytes[55:48]));
  aes_Sbox aes_sbox11(.sbox_in(subBytes_in[47:40]),  .aes128_sbox(after_subBytes[47:40]));
  aes_Sbox aes_sbox12(.sbox_in(subBytes_in[39:32]),  .aes128_sbox(after_subBytes[39:32]));
  aes_Sbox aes_sbox13(.sbox_in(subBytes_in[31:24]),  .aes128_sbox(after_subBytes[31:24]));
  aes_Sbox aes_sbox14(.sbox_in(subBytes_in[23:16]),  .aes128_sbox(after_subBytes[23:16]));
  aes_Sbox aes_sbox15(.sbox_in(subBytes_in[15:8]),   .aes128_sbox(after_subBytes[15:8]));
  aes_Sbox aes_sbox16(.sbox_in(subBytes_in[7:0]),    .aes128_sbox(after_subBytes[7:0]));

endmodule

