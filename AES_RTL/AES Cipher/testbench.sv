// Code your testbench here
// or browse Examples
module tb_cipher_top;
  //input
  reg clk;
  reg rst_n;
  reg	[127:0]	cipher_key;
  reg	[127:0]	plain_text;
  reg cipher_en;
  //output
  wire [127:0] cipher_text;
  wire         cipher_ready;
  //
  AES_Cipher aes_cipher_top(
    .clk(clk),
    .rst_n(rst_n),
    .plain_text(plain_text),
    .cipher_key(cipher_key),
    .cipher_text(cipher_text),
    .cipher_ready(cipher_ready)
  );
  
  
  initial begin
    clk = 0;
    rst_n = 0;
    cipher_key = 0;
    plain_text = 0;
  end
  initial begin
    forever #5 clk = ~clk;
  end
  initial begin
    $dumpfile("dump.vcd"); $dumpvars;
    
    plain_text = 128'h3243f6a8885a308d313198a2e0370734;
    cipher_key = 128'h2b7e151628aed2a6abf7158809cf4f3c;
    #10
    rst_n = 1;
    #100
    wait(cipher_ready == 1);
    $display ("---- cipher_text: %32h - READY: %1b\n", cipher_text[127:0], cipher_ready);
   	#10
    rst_n = 0;
    #10
    plain_text = 128'h00112233445566778899aabbccddeeff;
    cipher_key = 128'ha5a5a5a5a5a5a5a5a5a5a5a5a5a5a5a5;
    #10
    rst_n=1;
    
    #100
    wait(cipher_ready == 1);
    $display ("---- cipher_text: %32h - READY: %1b\n", cipher_text[127:0], cipher_ready);
    #20
    $stop;
  end

endmodule