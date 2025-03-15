// Code your design here
`include "AES_Cipher_Controller.v"
`include "AddRoundKey.v"
`include "SubBytes.v"
`include "ShiftRows.v"
`include "MixColumns.v"
module Cipher_Core(
  input wire clk,
  input wire rst_n,
  input wire [127:0] plain_text,
  input wire [127:0] cipher_key,
  input wire [127:0] round_key,
  
  output wire [127:0] cipher_text,
  output reg begin_round,
  output reg rkey_en,
  output reg [3:0] round_num,
  output reg cipher_ready
  
);
  reg cipher_complete;
  wire [127:0] key_in, addRoundKey_in, after_addRoundKey;
  wire [127:0] mixColumn_in, after_mixColumns;
  reg [127:0] cipher_text_reg;
  wire [127:0] subBytes_sel,after_subBytes;
  wire [127:0] after_shiftRows;
  AES_controller aes_controller (
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
  AddRoundKey addroundkey(.addRoundKey_in(addRoundKey_in),.round_key(key_in),.after_addRoundKey(after_addRoundKey));
  always@(posedge clk or negedge rst_n)	begin
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
  //-------------------------------------------------------------------
  //SubBytes - converts the previous data to the cipher tables's value
  //-------------------------------------------------------------------
  //generating the SubBytes selection signal
  assign subBytes_sel[127:120]	= cipher_text_reg[127:120];
  assign subBytes_sel[119:112]	= cipher_text_reg[95:88];
  assign subBytes_sel[111:104]	= cipher_text_reg[63:56];
  assign subBytes_sel[103:96]	  = cipher_text_reg[31:24];
  assign subBytes_sel[95:88]	  = cipher_text_reg[119:112];
  assign subBytes_sel[87:80]	  = cipher_text_reg[87:80];
  assign subBytes_sel[79:72]	  = cipher_text_reg[55:48];
  assign subBytes_sel[71:64]	  = cipher_text_reg[23:16];
  assign subBytes_sel[63:56]	  = cipher_text_reg[111:104];
  assign subBytes_sel[55:48]	  = cipher_text_reg[79:72];
  assign subBytes_sel[47:40]	  = cipher_text_reg[47:40];
  assign subBytes_sel[39:32]	  = cipher_text_reg[15:8];
  assign subBytes_sel[31:24]	  = cipher_text_reg[103:96];
  assign subBytes_sel[23:16]	  = cipher_text_reg[71:64];
  assign subBytes_sel[15:8]	    = cipher_text_reg[39:32];
  assign subBytes_sel[7:0]	    = cipher_text_reg[7:0];
  //------------------------------------------------------------------------
  // SubBytes - Sbox
  //------------------------------------------------------------------------
  SubByte subbytes(.subBytes_sel(subBytes_sel),.after_subBytes(after_subBytes));
  //------------------------------------------------------------------------
  // ShiftRows - Actual is a rotate
  //------------------------------------------------------------------------
  ShiftRows shiftrows(.after_subBytes(after_subBytes),.after_shiftRows(after_shiftRows));
  //----------------------------------------------------------------------------
  //MixColumns - the matrix multiplication a(x) = {03}x3 + {01}x2 + {01}x + {02}
  //----------------------------------------------------------------------------
  //----------------------------------------------------------------------------
  // Convert the bit stream to columns
  //----------------------------------------------------------------------------
  assign mixColumn_in[127:96]	= {after_shiftRows[127:120],
                                   after_shiftRows[95:88],
  				                   after_shiftRows[63:56],
                                   after_shiftRows[31:24]};
                                 
  assign mixColumn_in[95:64]	= {after_shiftRows[119:112],
                                   after_shiftRows[87:80],
  				                   after_shiftRows[55:48],
                                   after_shiftRows[23:16]};
                                 
  assign mixColumn_in[63:32]	= {after_shiftRows[111:104],
                                   after_shiftRows[79:72],
  				                   after_shiftRows[47:40],
                                   after_shiftRows[15:8]};
                                 
  assign mixColumn_in[31:0]	= {after_shiftRows[103:96],
                                   after_shiftRows[71:64],
  				                   after_shiftRows[39:32],
                                   after_shiftRows[7:0]};
  //----------------------------------------------------------------------------
  //The MixColumn function
  //----------------------------------------------------------------------------
  mixColumns mixcolumn(.mixColumn_in(mixColumn_in),.after_mixColumns(after_mixColumns));
  
  assign cipher_text= (cipher_ready)? cipher_text_reg : 128'h0;
  
endmodule