// Code your design here
`include "rotWord.sv"
`include "InvRcon.sv"
`include "subWord.sv"

module AES_Inv_Key_Expand(
  input logic clk,
  input logic rst_n,
  input logic [127:0] round_key_10,
  input logic [3:0] round_num,
  input logic rkey_en,
  input logic begin_round,
  
  output logic [127:0] round_key_out
);
  logic [127:0] key_in;
  logic [31:0] rotW_in;
  logic [127:0] round_key;
  logic [31:0] after_rotW;
  logic [31:0] after_subW;
  logic [31:0] after_inv_rcon;
  logic [127:0] round_key_reg;
  logic [31:0] after_addRcon;
  always_comb	begin
    if(begin_round)	begin
      key_in=round_key_10;
    end
    else	begin
      key_in=round_key_reg;
    end
  end
  assign rotW_in=key_in[63:32]^key_in[31:0];
  rotWord u_rotW(.key_in(rotW_in),.after_rotW(after_rotW));
  subWord u_subW(.after_rotW(after_rotW),.after_subW(after_subW));
  InvRcon u_invrcon(.round_num(round_num),.after_inv_rcon(after_inv_rcon));
  assign after_addRcon = after_inv_rcon ^ after_subW;
  assign round_key[127:96] = after_addRcon ^ key_in[127:96];
  assign round_key[95:64] = key_in[127:96] ^ key_in[95:64];
  assign round_key[63:32] = key_in[95:64] ^ key_in[63:32];
  assign round_key[31:0] = key_in[63:32] ^ key_in[31:0];
  always_ff@(posedge clk or negedge rst_n)	begin
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
  assign round_key_out=(begin_round)? 128'h0: round_key_reg;
endmodule
