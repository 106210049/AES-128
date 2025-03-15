// Code your design here
// `include "rotWord.v"
`include "InvRcon.v"
// `include "subWord.v"

module AES_Inv_Key_Expand(
  input wire clk,
  input wire rst_n,
  input wire [127:0] round_key_10,
  input wire [3:0] round_num,
  input wire rkey_en,
  input wire begin_round,
  
  output wire [127:0] round_key_out
);
  reg [127:0] key_in;
  wire [31:0] rotW_in;
  wire [127:0] round_key;
  wire [31:0] after_rotW;
  wire [31:0] after_subW;
  wire [31:0] after_inv_rcon;
  reg [127:0] round_key_reg;
  wire [31:0] after_addRcon;
  always@(*)	begin
    if(begin_round)	begin
      key_in=round_key_10;
    end
    else	begin
      key_in=round_key_reg;
    end
  end
  assign rotW_in=key_in[63:32]^key_in[31:0];
  rotWord rotW(.key_in(rotW_in),.after_rotW(after_rotW));
  subWord subW(.after_rotW(after_rotW),.after_subW(after_subW));
  InvRcon invrcon(.round_num(round_num),.after_inv_rcon(after_inv_rcon));
  assign after_addRcon = after_inv_rcon ^ after_subW;
  assign round_key[127:96] = after_addRcon ^ key_in[127:96];
  assign round_key[95:64] = key_in[127:96] ^ key_in[95:64];
  assign round_key[63:32] = key_in[95:64] ^ key_in[63:32];
  assign round_key[31:0] = key_in[63:32] ^ key_in[31:0];
  always@(posedge clk or negedge rst_n)	begin
    if(!rst_n)	begin
      round_key_reg<=128'h0;
    end
    else begin
      if(begin_round^rkey_en)	begin
      	round_key_reg<=round_key;
      end
      else begin
        round_key_reg<=round_key_reg;
      end
    end
  end
  assign round_key_out=round_key_reg;
endmodule