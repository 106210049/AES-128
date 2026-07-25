class monitor;

    mailbox mon_to_scb;
    virtual aes_if vif;

    function new(mailbox mon_to_scb, virtual aes_if vif);
        this.mon_to_scb = mon_to_scb;
        this.vif        = vif;
    endfunction

    task run();
        transaction tr;
        forever begin
            @(posedge vif.finished); // chờ DUT báo xong
            if(vif.rst_n) begin
                tr = new();
                tr.data_in  = vif.data_in;
                tr.key      = vif.key;
                tr.data_out = vif.data_out;
                tr.finished = vif.finished;
                tr.display("MON");
                mon_to_scb.put(tr); // gửi sang scoreboard
            end
        end
    endtask

endclass
