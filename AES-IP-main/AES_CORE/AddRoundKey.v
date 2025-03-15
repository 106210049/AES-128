module AddRoundKey (
  input wire [127:0] addRoundKey_in,   // plaintext or result of mixcolumn
  input wire [127:0] round_key,  // Key cipher or Round key from Key Expand
  output wire [127:0] after_addRoundKey  
);

    // XOR between state and roundkey
    assign after_addRoundKey = addRoundKey_in ^ round_key;

endmodule
