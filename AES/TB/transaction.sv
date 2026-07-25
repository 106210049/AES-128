import testcase_pkg::*;
class transaction;

    rand bit [127:0]    data_in;
    rand bit [127:0]    key;
    bit      [127:0]    data_out;
    test_case           tc;
    bit                 finished;

    constraint data_in_c { data_in inside {[0:2**128-1]}; }
    constraint key_c { key inside {[0:2**128-1]}; }

    function new ();
        this.data_in = 128'h0;
        this.key = 128'h0;
    endfunction

    function void display(string tag = "TRANS");
        $display("[%0t][%s] data_in: %h, key: %h, data_out: %h, finished: %b", $time, tag, data_in, key, data_out, finished);
    endfunction

   

endclass