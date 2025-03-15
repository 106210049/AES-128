module InvShiftRows(
  input wire [127:0] invShiftRows_in,  //  Đầu vào từ AddRoundKey
  output wire [127:0] after_invShiftRows // Đầu ra sau khi dịch ngược
);
  
  // Row 0: No shift
  assign after_invShiftRows[127:120] = invShiftRows_in[127:120];
  assign after_invShiftRows[119:112] = invShiftRows_in[119:112];
  assign after_invShiftRows[111:104] = invShiftRows_in[111:104];
  assign after_invShiftRows[103:96]  = invShiftRows_in[103:96];

  // Row 1: Right shift by 1 byte
  assign after_invShiftRows[95:88]   = invShiftRows_in[71:64];
  assign after_invShiftRows[87:80]   = invShiftRows_in[95:88];
  assign after_invShiftRows[79:72]   = invShiftRows_in[87:80];
  assign after_invShiftRows[71:64]   = invShiftRows_in[79:72];

  // Row 2: Right shift by 2 bytes
  assign after_invShiftRows[63:56]   = invShiftRows_in[47:40];
  assign after_invShiftRows[55:48]   = invShiftRows_in[39:32];
  assign after_invShiftRows[47:40]   = invShiftRows_in[63:56];
  assign after_invShiftRows[39:32]   = invShiftRows_in[55:48];

  // Row 3: Right shift by 3 bytes
  assign after_invShiftRows[31:24]   = invShiftRows_in[23:16];
  assign after_invShiftRows[23:16]   = invShiftRows_in[15:8];
  assign after_invShiftRows[15:8]    = invShiftRows_in[7:0];
  assign after_invShiftRows[7:0]     = invShiftRows_in[31:24];

endmodule
