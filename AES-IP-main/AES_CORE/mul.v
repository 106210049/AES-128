module mul(
  input wire [7:0] mul_in,
  output reg [7:0] mul2_out,
  output wire [7:0] mul3_out
);
  always@(*)	begin 
    if(mul_in[7]==1)	begin
      mul2_out={mul_in[6:0],1'b0}^8'b0001_1011;
    end
    else begin
      mul2_out={mul_in[6:0],1'b0};
    end
  end
  assign mul3_out= mul2_out^mul_in;
endmodule