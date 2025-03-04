// Code your testbench here
// or browse Examples
`timescale 1ns / 1ps
`define CIPHER
module AES_CORE_TB;

    // Testbench signals
    reg [127:0] data_in;
    reg [127:0] key;
    reg clk;
    reg rst_n;
    wire [127:0] data_out;
    wire finished;

    // Instantiate the AES_CORE module
    AES_CORE uut (
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
      $dumpfile("dump.vcd"); $dumpvars;
        // Initialize inputs
        clk = 0;
        rst_n = 0;
        `ifdef CIPHER
        data_in = 128'h00112233445566778899AABBCCDDEEFF; // Sample input
        key = 128'h000102030405060708090A0B0C0D0E0F;  // Sample key
        `endif 
        // Reset sequence
        #10 rst_n = 1;

        // Wait for operation to complete
      	#100
        wait (finished);
        $display("AES Operation Completed. Output: %h", data_out);

        #20;
        
        `ifdef DECIPHER
            // Save encrypted data for decryption test
            data_in = data_out;
            key = 128'h0F0E0D0C0B0A09080706050403020100; // Example decryption key
        `endif
        
        #10 rst_n = 0;
        #10 rst_n = 1;

        // Wait for decryption operation
        wait (finished);
        $display("AES Decryption Completed. Output: %h", data_out);

        // End simulation
        #20;
        $stop;
    end
endmodule
