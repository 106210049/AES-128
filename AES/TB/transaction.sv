import testcase_pkg::*;
class transaction;

    rand bit [127:0]    data_in;
    rand bit [127:0]    key;
    bit      [127:0]    data_out;
    test_case           tc;
    bit                 finished;

    constraint data_in_c { data_in inside {[128'h0:128'hFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF]}; }
    constraint key_c { key inside {[128'h0:128'hFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF]}; }

    covergroup cov_aes_input;
        cp_data_in: coverpoint data_in {
            `ifdef DECIPHER
            bins fixed_data = {128'h69C4E0D86A7B0430D8CDB78070B4C55A};
            `else
            bins fixed_data = {128'h00112233445566778899AABBCCDDEEFF};
            `endif
            bins random_data = {[128'h0:128'hFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF]};
        }

        cp_key_in: coverpoint key {
            `ifdef DECIPHER
            bins fixed_key = {128'h13111D7FE3944A17F307A78B4D2B30C5};
            `else
            bins fixed_key = {128'h000102030405060708090A0B0C0D0E0F};
            `endif
            bins random_key = {[128'h0:128'hFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF]};
        }
    endgroup

    function new ();
        this.data_in = 128'h0;
        this.key = 128'h0;
        cov_aes_input = new();
    endfunction

    function void sample_coverage();
        if(cov_aes_input != null)   cov_aes_input.sample();
    endfunction

    function void display(string tag = "TRANS");
        $display("[%0t][%s] data_in: %h, key: %h, data_out: %h, finished: %b", $time, tag, data_in, key, data_out, finished);
    endfunction

   

endclass