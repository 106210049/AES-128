package aes_pkg;
    import uvm_pkg::*;
    `include "uvm_macros.svh"
    typedef uvm_config_db#( virtual aes_if ) aes_if_db;
    typedef virtual aes_if aes_vif;

    `include "aes_transaction.sv"
    `include "aes_monitor.sv"
    `include "aes_driver.sv"
    `include "aes_sequencer.sv"
    `include "aes_scoreboard.sv"
    `include "aes_env.sv"
    `include "../Test/test.sv"
    `include "../Test/encryption/aes_test_definetion_enc/aes_test_definetion_enc.sv"
    `include "../Test/encryption/aes_test_continuous_enc/aes_test_continuous_enc.sv"
    `include "../Test/encryption/aes_test_special_data_enc/aes_test_special_data_enc.sv"

    `include "../Test/decryption/aes_test_definetion_dec/aes_test_definetion_dec.sv"
    `include "../Test/decryption/aes_test_continuous_dec/aes_test_continuous_dec.sv"
    `include "../Test/decryption/aes_test_special_data_dec/aes_test_special_data_dec.sv"

    //`include "../Test/reset/aes_test_reset_enc/aes_test_reset_enc.sv"
   // `include "../Test/reset/aes_test_reset_dec/aes_test_reset_dec.sv"
endpackage: aes_pkg