// Code your design here
module AES_decipher_controller(
  input wire clk,
  input wire rst_n,
  
  output reg [3:0] round_num,
  output reg decipher_ready,
  output wire begin_round,
  output wire rkey_en,
  output wire first_time_en
);
  wire decipher_complete;
  always@(posedge clk or negedge rst_n)	begin
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
  always@(posedge clk or negedge rst_n)	begin
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