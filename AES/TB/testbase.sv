// Code your testbench here
// or browse Examples
// `timescale 1ns / 1ps
// // `define CIPHER
module tb_aes_core;

    // Testbench signals
    reg [127:0] data_in;
    reg [127:0] key;
    reg clk;
    reg rst_n;
    logic [127:0] data_out;
    logic finished;

    // Instantiate the AES_CORE module
    aes_top dut (
        .data_in(data_in),
        .key(key),
        .clk(clk),
        .rst_n(rst_n),
        .data_out(data_out),
        .finished(finished)
    );

    // Clock generation
    always #5 clk = ~clk; // 10ns period (100 MHz)

    initial begin
        // Initialize inputs
        clk = 0;
        rst_n = 0;
        `ifdef DECIPHER
            // Save encrypted data for decryption test
            data_in = 128'hf955b1b5e6f2c07b8cf133f3660447e9;
            key = 128'h1008bf076f5df11fd5586142e6a96849; // Example decryption key
        `else 
            data_in = 128'h00112233445566778899AABBCCDDEEFF; // Sample input
            key = 128'h000102030405060708090A0B0C0D0E0F;  // Sample key
        `endif
    
        // Reset sequence
        #10 rst_n = 1;

        // Wait for operation to complete
        // @(posedge finished);
        // $display("AES Operation Completed. Output: %h", data_out);
        // data_in = 128'h00112233445566778899aabbccddeeff;    
        // key = 128'ha5a5a5a5a5a5a5a5a5a5a5a5a5a5a5a5; 
        // @(posedge finished);
        // $display("AES Operation Completed. Output: %h", data_out);

        // #10 rst_n = 0;
        // #10 rst_n = 1;

        // Wait for decryption operation
        wait (finished);
        $display("AES Decryption Completed. Output: %h", data_out);

        // End simulation
        #20;
        $stop;
    end
endmodule

