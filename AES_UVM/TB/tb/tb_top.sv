`timescale 1ns/1ns

module tb_aes_top;
    import uvm_pkg::*;
    `include "uvm_macros.svh"
    import aes_pkg::*;
    `include "../sv/aes_scoreboard.sv"
    `include "aes_tb.sv"
    `include "aes_test_lib.sv"
    
    // Clock & reset
    logic clk;
    logic rst_n;

    // Clock generation
    initial clk = 0;
    initial rst_n = 1;
    always #5 clk = ~clk;

    // Reset generation
    initial begin
        @(posedge clk);
        #1 rst_n <= 1'b0;
        @(posedge clk);
        #1 rst_n <= 1'b1;
    end

    // Interface instance
    aes_if vif(clk, rst_n);

    // DUT instance
    aes_top uut (
        .data_in(vif.data_in),
        .key(vif.key),
        .clk(clk),
        .rst_n(rst_n),
        .data_out(vif.data_out),
        .finished(vif.finished)
    );
   

    // Dump waveform
    initial begin
        $dumpfile("aes.vcd");
        $dumpvars(0, tb_aes_top);
    end

    // UVM run
    initial begin
        // cấu hình virtual interface cho agent
        aes_vif_config::set(null, "*.tb.env.agent.*", "vif", vif);
        run_test();
    end
        
endmodule
