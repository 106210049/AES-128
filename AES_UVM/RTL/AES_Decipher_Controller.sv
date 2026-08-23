// Code your design here
module AES_Decipher_Controller(
  input logic clk,
  input logic rst_n,
  
  output logic [3:0] round_num,
  output logic decipher_ready,
  output logic begin_round,
  output logic rkey_en,
  output logic first_time_en
);
  logic decipher_complete;
  always_ff@(posedge clk or negedge rst_n)	begin
    if(!rst_n)	begin
      round_num<=4'd0;
    end
    else	begin
      if(decipher_complete)	begin
        round_num<=4'd0;
      end
      else if(rkey_en|begin_round)	begin
        round_num<=round_num+4'd1;
      end
      else	begin
        round_num<=round_num;
      end
    end
  end
  assign decipher_complete=(round_num==10)? 1'b1:1'b0;
  assign begin_round=(round_num==0)? 1'b1:1'b0;
  assign first_time_en = (round_num==1)? 1'b1:1'b0;
  always_ff@(posedge clk or negedge rst_n)	begin
    if(!rst_n)	begin
      decipher_ready<=1'b1;
    end
    else	begin
      if(decipher_complete)	begin
          decipher_ready<=1'b1;
        end
        else	begin
          decipher_ready<=1'b0;
        end
    end
  end
  assign rkey_en= ~decipher_ready;
endmodule
