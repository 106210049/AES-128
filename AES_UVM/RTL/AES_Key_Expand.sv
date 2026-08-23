// Code your design here
`include"rotWord.sv"
`include "subWord.sv"
`include "Rcon.sv"
`include "addWord.sv"
module AES_Key_Expand(
  input logic clk,
  input logic rst_n,
  input logic [3:0] round_num,
  input logic [127:0] cipher_key,
  input logic begin_round,
  input logic rkey_en,
  
  output logic [127:0] round_key_out
);
  logic [127:0] key_in;
  logic [127:0] round_key_reg;
  logic [31:0] after_rotW;
  logic [31:0] after_subW;
  logic [31:0] after_rcon;
  logic [31:0] after_addRcon;
  logic [127:0] round_key;
  always_comb	begin
    if(begin_round)	begin
      key_in=cipher_key;
    end
    else	begin
       key_in=round_key_reg;
    end
  end
  rotWord u_rotW(.key_in(key_in[31:0]),.after_rotW(after_rotW));
  subWord u_subW(.after_rotW(after_rotW),.after_subW(after_subW));
  Rcon u_rcon(.round_num(round_num), .after_rcon(after_rcon));
  assign after_addRcon=after_subW ^ after_rcon;
  addWord u_addW(.key_in(key_in), .after_addRcon(after_addRcon),.round_key(round_key));
  
  always_ff@(posedge clk or negedge rst_n)	begin
    if(!rst_n)	begin
      round_key_reg<=128'd0;
    end
    
    else if(begin_round|rkey_en)	begin
      round_key_reg<=round_key;
    end
    else begin
      round_key_reg<=round_key_reg;
    end
  end
  assign round_key_out= (begin_round)? 128'h0 : round_key_reg;
  
endmodule
