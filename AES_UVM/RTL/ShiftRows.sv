module ShiftRows(
  input  logic [127:0] ShiftRows_in,
  output logic [127:0] after_shiftRows
);

  // Row 0 (no shift)
  assign after_shiftRows[127:120] = ShiftRows_in[127:120];
  assign after_shiftRows[95:88]   = ShiftRows_in[95:88];
  assign after_shiftRows[63:56]   = ShiftRows_in[63:56];
  assign after_shiftRows[31:24]   = ShiftRows_in[31:24];

  // Row 1 (shift left 1)
  assign after_shiftRows[119:112] = ShiftRows_in[87:80];
  assign after_shiftRows[87:80]   = ShiftRows_in[55:48];
  assign after_shiftRows[55:48]   = ShiftRows_in[23:16];
  assign after_shiftRows[23:16]   = ShiftRows_in[119:112];

  // Row 2 (shift left 2)
  assign after_shiftRows[111:104] = ShiftRows_in[47:40];
  assign after_shiftRows[79:72]   = ShiftRows_in[15:8];
  assign after_shiftRows[47:40]   = ShiftRows_in[111:104];
  assign after_shiftRows[15:8]    = ShiftRows_in[79:72];

  // Row 3 (shift left 3)
  assign after_shiftRows[103:96]  = ShiftRows_in[7:0];
  assign after_shiftRows[71:64]   = ShiftRows_in[103:96];
  assign after_shiftRows[39:32]   = ShiftRows_in[71:64];
  assign after_shiftRows[7:0]     = ShiftRows_in[39:32];

endmodule
