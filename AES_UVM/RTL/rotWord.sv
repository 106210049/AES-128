module rotWord(
  input logic [31:0] key_in,
  output logic [31:0] after_rotW
);
  assign after_rotW= {key_in[23:0], key_in[31:24]};
endmodule
