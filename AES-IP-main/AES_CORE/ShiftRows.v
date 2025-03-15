module ShiftRows(
  input wire [127:0] after_subBytes,
  output wire [127:0] after_shiftRows
);
  
    // no shift
    assign after_shiftRows[127:120] = after_subBytes[127:120];
  	assign after_shiftRows[119:112] = after_subBytes[119:112];
  	assign after_shiftRows[111:104] = after_subBytes[111:104];
  	assign after_shiftRows[103:96]  = after_subBytes[103:96];
    // left-shift: one bytes
  	assign after_shiftRows[71:64] = after_subBytes[95:88];
  	assign after_shiftRows[95:88] = after_subBytes[87:80];
  	assign after_shiftRows[87:80] = after_subBytes[79:72];
  	assign after_shiftRows[79:72] = after_subBytes[71:64];
  	//left-shift: two bytes
  	assign after_shiftRows[47:40] = after_subBytes[63:56];
  	assign after_shiftRows[39:32] = after_subBytes[55:48];
  	assign after_shiftRows[63:56] = after_subBytes[47:40];
  	assign after_shiftRows[55:48] = after_subBytes[39:32];
    //left-shift: three bytes
  	assign after_shiftRows[23:16] = after_subBytes[31:24];
  	assign after_shiftRows[15:8]  = after_subBytes[23:16];
  	assign after_shiftRows[7:0]   = after_subBytes[15:8];
  	assign after_shiftRows[31:24] = after_subBytes[7:0];
endmodule