import testcase_pkg::*;
class generator;
    mailbox gen_to_drv;
    integer num_gen;
    test_case tc;

    transaction tr;

    function new(mailbox gen_to_drv);
        this.gen_to_drv = gen_to_drv;
        this.num_gen = 0;
    endfunction

    task encrypt_test();
        repeat(num_gen) begin
            tr = new();
            assert(tr.randomize() with {
                data_in inside {128'h00112233445566778899AABBCCDDEEFF};
                key inside {128'h000102030405060708090A0B0C0D0E0F};
            })else $fatal("[GEN] randomize failed");
            tr.tc = tc;
            tr.display("GEN");
            gen_to_drv.put(tr);
        end
    endtask

    task decrypt_test();
        repeat(num_gen) begin
            tr = new();
            assert(tr.randomize() with {
                data_in inside {128'h69C4E0D86A7B0430D8CDB78070B4C55A};
                key inside {128'h13111D7FE3944A17F307A78B4D2B30C5};
            })else $fatal("[GEN] randomize failed");
            tr.tc = tc;
            tr.display("GEN");
            gen_to_drv.put(tr);
        end
    endtask

    task random_test();
        repeat(num_gen) begin
            tr = new();
            assert(tr.randomize() with {
                data_in inside {[0:2**128-1]};
                key inside {[0:2**128-1]};
            })else $fatal("[GEN] randomize failed");
            tr.tc = tc;
            tr.display("GEN");
            gen_to_drv.put(tr);
        end
    endtask

    task run();
        case(tc)
            `ifdef DECIPHER
            STABLE_PROCESS, RANDOM_TEST: random_test();
            DECRYPT, MID_RESET_DECRYPT: decrypt_test();
            `else
            STABLE_PROCESS, RANDOM_TEST: random_test();
            ENCRYPT, MID_RESET_ENCRYPT: encrypt_test();   
            `endif
            default: $fatal("[GEN] Unknown test case");
        endcase
    endtask
endclass