class env;

agent agt;
scoreboard scb;
mailbox mon_to_scb;

function new(virtual aes_if vif);
    mon_to_scb = new();
    scb  = new(mon_to_scb);
    agt = new(vif, mon_to_scb);
endfunction


task run();
    fork : ENV_THREADS
      agt.run();
      scb.run();
    join_none
endtask

task report();
    scb.report();
endtask


endclass