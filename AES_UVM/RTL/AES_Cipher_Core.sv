// Code your design here
`include "AES_Cipher_Controller.sv"
`include "AddRoundKey.sv"
`include "SubBytes.sv"
`include "ShiftRows.sv"
`include "MixColumns.sv"
module AES_Cipher_Core(
  input logic clk,
  input logic rst_n,
  input logic [127:0] plain_text,
  input logic [127:0] cipher_key,
  input logic [127:0] round_key,
  
  output logic [127:0] cipher_text,
  output logic begin_round,
  output logic rkey_en,
  output logic [3:0] round_num,
  output logic cipher_ready
  
);
  logic cipher_complete;
  logic [127:0] key_in, addRoundKey_in, after_addRoundKey;
  logic [127:0] mixColumn_in, after_mixColumns;
  logic [127:0] cipher_text_reg;
  logic [127:0] ShiftRows_in, after_subBytes;
  logic [127:0] after_shiftRows;
  AES_Cipher_Controller u_cipher_controller (
    .clk(clk),
    .rst_n(rst_n),
    .round_num(round_num),
    .cipher_ready(cipher_ready),
    .begin_round(begin_round),
    .rkey_en(rkey_en),
    .cipher_complete(cipher_complete)
  );
  assign key_in=(begin_round)?cipher_key:round_key;
  assign addRoundKey_in=(begin_round)? plain_text: (cipher_complete)? mixColumn_in: after_mixColumns;
  AddRoundKey u_addroundkey(.addRoundKey_in(addRoundKey_in),.round_key(key_in),.after_addRoundKey(after_addRoundKey));
  always_ff@(posedge clk or negedge rst_n)	begin
    if(!rst_n)	begin
      cipher_text_reg<=128'h0;
    end
    else begin
      if(begin_round^rkey_en)	begin
        cipher_text_reg<=after_addRoundKey;
      end
      else begin
        cipher_text_reg<=cipher_text_reg;
      end
    end
  end
 
  //------------------------------------------------------------------------
  // SubBytes - Sbox
  //------------------------------------------------------------------------
  SubBytes u_subbytes(.subBytes_in(cipher_text_reg),.after_subBytes(after_subBytes));


  //------------------------------------------------------------------------
  // ShiftRows - Actual is a rotate
  //------------------------------------------------------------------------
  
  ShiftRows u_shiftrows(.ShiftRows_in(after_subBytes),.after_shiftRows(after_shiftRows));
  //----------------------------------------------------------------------------
  //MixColumns - the matrix multiplication a(x) = {03}x3 + {01}x2 + {01}x + {02}
  //----------------------------------------------------------------------------

    assign mixColumn_in = after_shiftRows;
                                
  //----------------------------------------------------------------------------
  //The MixColumn function
  //----------------------------------------------------------------------------
  MixColumns u_mixcolumn(.mixColumn_in(mixColumn_in),.after_mixColumns(after_mixColumns));
  
  assign cipher_text= (cipher_ready)? cipher_text_reg : 128'h0;
  
endmodule
