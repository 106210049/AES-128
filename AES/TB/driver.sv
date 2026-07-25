class driver;

    mailbox gen_to_drv;
    virtual aes_if vif;

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

    task run();
        transaction tr;
        forever begin
            gen_to_drv.get(tr);

            case (tr.tc)

                RANDOM_TEST: begin
                    // drive_reset();
                    // Chờ core hoàn thành khối trước
                    wait (vif.finished == 1);
                    #0;
                    // Nạp dữ liệu mới ngay tại sườn lên finished
                    vif.data_in = tr.data_in;
                    vif.key     = tr.key;
                    tr.display("DRV");
                    // Chờ finished lần kế tiếp để lấy output
                    @(posedge vif.finished);
                    $display("[%0t][DRV] RANDOM_TEST done, Output=%h", $time, vif.data_out);
                end

                `ifdef DECIPHER
                    DECRYPT: begin
                        // drive_reset();
                        wait (vif.finished == 1);
                        #0;
                        vif.data_in = tr.data_in;
                        vif.key     = tr.key;
                        tr.display("DRV");
                        @(posedge vif.finished);
                        $display("[%0t][DRV] DECRYPT done, Output=%h", $time, vif.data_out);
                    end
                    MID_RESET_DECRYPT: begin
                        // drive_reset();
                        fork
                            begin
                                wait (vif.finished == 1);
                                #0;
                                vif.data_in = tr.data_in;
                                vif.key     = tr.key;
                                tr.display("DRV");
                                @(posedge vif.finished);
                                $display("[%0t][DRV] MID_RESET_DECRYPT done, Output=%h", $time, vif.data_out);
                            end
                            begin
                                repeat(5) @(posedge vif.clk);
                                $display("[%0t][DRV] Mid-reset DECRYPT", $time);
                                vif.rst_n = 0;
                                repeat(2) @(posedge vif.clk);
                                vif.rst_n = 1;
                            end
                        join
                    end
                `else
                    ENCRYPT: begin
                        // drive_reset();
                        wait (vif.finished == 1);
                        #0;
                        vif.data_in = tr.data_in;
                        vif.key     = tr.key;
                        tr.display("DRV");
                        @(posedge vif.finished);
                        $display("[%0t][DRV] ENCRYPT done, Output=%h", $time, vif.data_out);
                    end
                    MID_RESET_ENCRYPT: begin
                        // drive_reset();
                        fork
                            begin
                                wait (vif.finished == 1);
                                #0;
                                vif.data_in = tr.data_in;
                                vif.key     = tr.key;
                                tr.display("DRV");
                                @(posedge vif.finished);
                                $display("[%0t][DRV] MID_RESET_ENCRYPT done, Output=%h", $time, vif.data_out);
                            end
                            begin
                                repeat(7) @(posedge vif.clk);
                                $display("[%0t][DRV] Mid-reset ENCRYPT", $time);
                                vif.rst_n = 0;
                                repeat(2) @(posedge vif.clk);
                                vif.rst_n = 1;
                            end
                        join
                    end
                `endif
                default: $fatal("[%0t][DRV] Unknown test case", $time);

            endcase
        end
    endtask

endclass
