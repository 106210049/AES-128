module addWord(
  input wire [127:0] key_in,
  input wire [31:0] after_addRcon,
  output wire [127:0] round_key
  
);
  assign round_key[127:96] = key_in[127:96] ^ after_addRcon;
  assign round_key[95:64] = key_in[95:64] ^ round_key[127:96];
  assign round_key[63:32] = key_in[63:32] ^  round_key[95:64];
  assign round_key[31:0] =  round_key[63:32] ^  key_in[31:0];
endmodule