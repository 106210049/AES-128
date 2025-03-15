// SubByte
`include "aes_Sbox.v"

module SubByte(
  input wire [127:0] subBytes_sel, 
  output wire [127:0] after_subBytes 
);
  aes_Sbox aes_sbox1(.sbox_in(subBytes_sel[127:120]), .aes128_sbox(after_subBytes[127:120]));
  aes_Sbox aes_sbox2(.sbox_in(subBytes_sel[119:112]), .aes128_sbox(after_subBytes[119:112]));
  aes_Sbox aes_sbox3(.sbox_in(subBytes_sel[111:104]), .aes128_sbox(after_subBytes[111:104]));
  aes_Sbox aes_sbox4(.sbox_in(subBytes_sel[103:96]),  .aes128_sbox(after_subBytes[103:96]));
  aes_Sbox aes_sbox5(.sbox_in(subBytes_sel[95:88]),   .aes128_sbox(after_subBytes[95:88]));
  aes_Sbox aes_sbox6(.sbox_in(subBytes_sel[87:80]),   .aes128_sbox(after_subBytes[87:80]));
  aes_Sbox aes_sbox7(.sbox_in(subBytes_sel[79:72]),   .aes128_sbox(after_subBytes[79:72]));
  aes_Sbox aes_sbox8(.sbox_in(subBytes_sel[71:64]),   .aes128_sbox(after_subBytes[71:64]));
  aes_Sbox aes_sbox9(.sbox_in(subBytes_sel[63:56]),   .aes128_sbox(after_subBytes[63:56]));
  aes_Sbox aes_sbox10(.sbox_in(subBytes_sel[55:48]),  .aes128_sbox(after_subBytes[55:48]));
  aes_Sbox aes_sbox11(.sbox_in(subBytes_sel[47:40]),  .aes128_sbox(after_subBytes[47:40]));
  aes_Sbox aes_sbox12(.sbox_in(subBytes_sel[39:32]),  .aes128_sbox(after_subBytes[39:32]));
  aes_Sbox aes_sbox13(.sbox_in(subBytes_sel[31:24]),  .aes128_sbox(after_subBytes[31:24]));
  aes_Sbox aes_sbox14(.sbox_in(subBytes_sel[23:16]),  .aes128_sbox(after_subBytes[23:16]));
  aes_Sbox aes_sbox15(.sbox_in(subBytes_sel[15:8]),   .aes128_sbox(after_subBytes[15:8]));
  aes_Sbox aes_sbox16(.sbox_in(subBytes_sel[7:0]),    .aes128_sbox(after_subBytes[7:0]));

endmodule
