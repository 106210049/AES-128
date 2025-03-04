module rotWord(
  input wire [31:0] rotW_in,
  output wire [31:0] after_rotW
);
  assign after_rotW= {rotW_in[23:0], rotW_in[31:24]};
endmodule