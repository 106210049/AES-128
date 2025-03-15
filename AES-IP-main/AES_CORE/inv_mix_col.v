`include "decipher_mul.v"
module inv_mix_col (
    input wire [31:0] inv_mixColumns_in, 
    output wire [31:0] after_inv_mixColumns
);
   
    wire [7:0] byte15 = inv_mixColumns_in[31:24]; 
    wire [7:0] byte14 = inv_mixColumns_in[23:16];
    wire [7:0] byte13 = inv_mixColumns_in[15:8];  
    wire [7:0] byte12 = inv_mixColumns_in[7:0];   

    
    wire [7:0] byte15_mul2, byte15_mul4, byte15_mul8;
    wire [7:0] byte14_mul2, byte14_mul4, byte14_mul8;
    wire [7:0] byte13_mul2, byte13_mul4, byte13_mul8;
    wire [7:0] byte12_mul2, byte12_mul4, byte12_mul8;

    wire [7:0] byte15_mul0e, byte15_mul0b, byte15_mul0d, byte15_mul09;
    wire [7:0] byte14_mul0e, byte14_mul0b, byte14_mul0d, byte14_mul09;
    wire [7:0] byte13_mul0e, byte13_mul0b, byte13_mul0d, byte13_mul09;
    wire [7:0] byte12_mul0e, byte12_mul0b, byte12_mul0d, byte12_mul09;

    decipher_mul mul15(.inv_mixColumns_in(byte15), .mul2_out(byte15_mul2), .mul4_out(byte15_mul4), .mul8_out(byte15_mul8));
    decipher_mul mul14(.inv_mixColumns_in(byte14), .mul2_out(byte14_mul2), .mul4_out(byte14_mul4), .mul8_out(byte14_mul8));
    decipher_mul mul13(.inv_mixColumns_in(byte13), .mul2_out(byte13_mul2), .mul4_out(byte13_mul4), .mul8_out(byte13_mul8));
  	decipher_mul mul12(.inv_mixColumns_in(byte12), .mul2_out(byte12_mul2), .mul4_out(byte12_mul4), .mul8_out(byte12_mul8));

    assign byte15_mul0e = byte15_mul8 ^ byte15_mul4 ^ byte15_mul2;
    assign byte15_mul0b = byte15 ^ byte15_mul8 ^ byte15_mul2;
    assign byte15_mul0d = byte15 ^ byte15_mul8 ^ byte15_mul4;
    assign byte15_mul09 = byte15 ^ byte15_mul8;

    assign byte14_mul0e = byte14_mul8 ^ byte14_mul4 ^ byte14_mul2;
    assign byte14_mul0b = byte14 ^ byte14_mul8 ^ byte14_mul2;
    assign byte14_mul0d = byte14 ^ byte14_mul8 ^ byte14_mul4;
    assign byte14_mul09 = byte14 ^ byte14_mul8;

    assign byte13_mul0e = byte13_mul8 ^ byte13_mul4 ^ byte13_mul2;
    assign byte13_mul0b = byte13 ^ byte13_mul8 ^ byte13_mul2;
    assign byte13_mul0d = byte13 ^ byte13_mul8 ^ byte13_mul4;
    assign byte13_mul09 = byte13 ^ byte13_mul8;

    assign byte12_mul0e = byte12_mul8 ^ byte12_mul4 ^ byte12_mul2;
    assign byte12_mul0b = byte12 ^ byte12_mul8 ^ byte12_mul2;
    assign byte12_mul0d = byte12 ^ byte12_mul8 ^ byte12_mul4;
    assign byte12_mul09 = byte12 ^ byte12_mul8;

    assign after_inv_mixColumns[31:24] = byte15_mul0e ^ byte14_mul0b ^ byte13_mul0d ^ byte12_mul09; 
    assign after_inv_mixColumns[23:16] = byte15_mul09 ^ byte14_mul0e ^ byte13_mul0b ^ byte12_mul0d; 
    assign after_inv_mixColumns[15:8]  = byte15_mul0d ^ byte14_mul09 ^ byte13_mul0e ^ byte12_mul0b; 
    assign after_inv_mixColumns[7:0]   = byte15_mul0b ^ byte14_mul0d ^ byte13_mul09 ^ byte12_mul0e; 
endmodule