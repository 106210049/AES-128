// Code your testbench here
// or browse Examples
module tb_decipher_top;
  //input
  reg clk;
  reg rst_n;
  reg	[127:0]	round_key_10;
  reg	[127:0]	cipher_text;
  reg cipher_en;
  //output
  wire [127:0] plain_text;
  wire         decipher_ready;
  //
  AES_Decipher aes_decipher_top (
    .clk(clk),
    .rst_n(rst_n),
    .cipher_text(cipher_text),
    .round_key_10(round_key_10),
    
    .plain_text(plain_text),
    .decipher_ready(decipher_ready)
  );
  
  
  initial begin
    clk = 0;
    rst_n = 0;
    round_key_10 = 0;
    cipher_text = 0;
  end
  always #5 clk = ~clk;
  initial begin
    $dumpfile("dump.vcd"); $dumpvars;
    
    
    #10
    rst_n = 1;
    cipher_text = 128'h3925841d02dc09fbdc118597196a0b32;
    round_key_10 = 128'hd014f9a8c9ee2589e13f0cc8b6630ca6;
    #100
    wait(decipher_ready == 1);
    $display ("---- plain_text: %32h - READY: %1b\n", plain_text[127:0], decipher_ready);
   	
    #5
    cipher_text = 128'h69c4e0d86a7b0430d8cdb78070b4c55a;
    round_key_10 = 128'h1311_1d7f_e394_4a17_f307_a78b_4d2b_30c5;
   
    #100
    wait(decipher_ready == 1);
    $display ("---- plain_text: %32h - READY: %1b\n", plain_text[127:0], decipher_ready);
    #20
    $stop;
  end

endmodule