// `include"aes_Sbox.v"
module subWord(
  input wire [31:0] after_rotW,
  output wire [31:0] after_subW
);
  wire [31:0] after_sbox;
  aes_Sbox aes_sbox1(.sbox_in(after_rotW[31:24]),.aes128_sbox(after_sbox[31:24]));
  aes_Sbox aes_sbox2(.sbox_in(after_rotW[23:16]),.aes128_sbox(after_sbox[23:16]));
  aes_Sbox aes_sbox3(.sbox_in(after_rotW[15:8]),.aes128_sbox(after_sbox[15:8]));
  aes_Sbox aes_sbox4(.sbox_in(after_rotW[7:0]),.aes128_sbox(after_sbox[7:0]));
  assign after_subW = after_sbox;
endmodule