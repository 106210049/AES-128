class driver;

    mailbox gen_to_drv;
    virtual aes_if vif;
    transaction tr;
    function new(mailbox gen_to_drv, virtual aes_if vif);
        this.gen_to_drv = gen_to_drv;
        this.vif        = vif;
    endfunction

    task drive_reset();
        vif.rst_n <= 0;
        repeat (2) @(posedge vif.clk);
        vif.rst_n <= 1;
        $display("[%0t][DRV] Reset done", $time);
    endtask

    task push_data();
        // drive_reset();
        wait (vif.finished == 1);
        #0;
        vif.data_in = tr.data_in;
        vif.key     = tr.key;
        tr.display("DRV");
        @(posedge vif.finished);
    endtask

    // task dive_toggle();
    //     wait (vif.finished == 1);
    //     #0;
    //     vif.data_in = tr.data_in;
    //     vif.key     = tr.key;
    //     repeat(3) @(posedge vif.clk);
    //     vif.data_in = 128'h0;
    //     vif.key     = 128'h0;
    //     repeat(2) @(posedge vif.clk);
    //     vif.data_in = tr.data_in;
    //     vif.key     = tr.key;
    //     tr.display("DRV");
    //     @(posedge vif.finished);
    // endtask

    task run();
        
        forever begin
            gen_to_drv.get(tr);
            case (tr.tc)
                
                `ifdef DECIPHER
                    RANDOM_TEST: begin
                        push_data();
                        $display("[%0t][DRV] RANDOM_TEST done, Output=%h", $time, vif.data_out);
                        end
                    STABLE_PROCESS: begin
                        fork
                            begin
                                push_data();
                            end

                            begin
                                repeat(3) @(posedge vif.clk);
                                vif.data_in = 128'h0;
                                vif.key     = 128'h0;
                                repeat(2) @(posedge vif.clk);
                                vif.data_in = tr.data_in;
                                vif.key     = tr.key;
                            end
                        join
                        $display("[%0t][DRV] STABLE_PROCESS done, Output=%h", $time, vif.data_out);
                        end
                    DECRYPT: begin
                       push_data();
                        $display("[%0t][DRV] DECRYPT done, Output=%h", $time, vif.data_out);
                    end
                    MID_RESET_DECRYPT: begin
                        // drive_reset();
                        fork
                            begin
                                push_data();
                                $display("[%0t][DRV] MID_RESET_DECRYPT done, Output=%h", $time, vif.data_out);
                            end
                            begin
                                repeat(5) @(posedge vif.clk);
                                $display("[%0t][DRV] Mid-reset DECRYPT", $time);
                                drive_reset();
                            end
                        join
                    end
                `else
                    RANDOM_TEST: begin
                        push_data();
                        $display("[%0t][DRV] RANDOM_TEST done, Output=%h", $time, vif.data_out);
                        end
                    STABLE_PROCESS: begin
                        fork
                            begin
                                push_data();
                            end

                            begin
                                repeat(3) @(posedge vif.clk);
                                vif.data_in = 128'h0;
                                vif.key     = 128'h0;
                                repeat(2) @(posedge vif.clk);
                                vif.data_in = tr.data_in;
                                vif.key     = tr.key;
                            end
                        join
                        $display("[%0t][DRV] STABLE_PROCESS done, Output=%h", $time, vif.data_out);
                        end
                    ENCRYPT: begin
                        // drive_reset();
                        push_data();
                        $display("[%0t][DRV] ENCRYPT done, Output=%h", $time, vif.data_out);
                    end
                    MID_RESET_ENCRYPT: begin
                        // drive_reset();
                        fork
                            begin
                                push_data();
                                $display("[%0t][DRV] MID_RESET_ENCRYPT done, Output=%h", $time, vif.data_out);
                            end
                            begin
                                repeat(7) @(posedge vif.clk);
                                $display("[%0t][DRV] Mid-reset ENCRYPT", $time);
                                drive_reset();
                            end
                        join
                    end
                `endif
                default: $fatal("[%0t][DRV] Unknown test case", $time);

            endcase
        end
    endtask

endclass
