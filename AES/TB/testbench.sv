import "DPI-C" function void AES128_ECB_encrypt_dpi(
    input  bit [127:0] data_in,
    input  bit [127:0] key,
    output bit [127:0] data_out
);

import "DPI-C" function void AES128_ECB_decrypt_dpi(
    input  bit [127:0] data_in,
    input  bit [127:0] key,
    output bit [127:0] data_out
);

`include "testcase_pkg.sv"
`include "interface.sv"
`include "transaction.sv"
`include "generator.sv"
`include "driver.sv"
`include "monitor.sv"
`include "scoreboard.sv"
`include "agent.sv"
`include "env.sv"
`include "test.sv"

import testcase_pkg::*;
module tb_aes_core;

// Clock & reset
  bit clk;
  bit rst_n;

  // Clock generator
  initial clk = 0;
  always #5 clk = ~clk;

  aes_if vif (clk, rst_n);

  aes_top dut (
    .data_in(vif.data_in),
    .key(vif.key),
    .clk(clk),
    .rst_n(vif.rst_n),
    .data_out(vif.data_out),
    .finished(vif.finished)
  );
  test t1(vif);
  // Reset sequence
  initial begin
    rst_n = 0;
    #5 rst_n = 1;
  end

  // Waveform dump
  initial begin
    $dumpfile("dump.vcd");
    $dumpvars(0, tb_aes_core);
  end

endmodule
