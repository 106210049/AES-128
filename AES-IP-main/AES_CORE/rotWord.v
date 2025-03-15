module rotWord(
  input wire [31:0] key_in,
  output wire [31:0] after_rotW
);
  assign after_rotW= {key_in[23:0], key_in[31:24]};
endmodule