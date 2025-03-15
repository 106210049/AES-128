class aes_env extends uvm_env;
    `uvm_component_utils(aes_env)
    aes_driver driver;
    aes_monitor monitor;
    aes_scoreboard scoreboard;
    uvm_sequencer#(aes_transaction) sequencer;
    virtual aes_if vif;
    function new(string name = "aes_env", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        driver = aes_driver::type_id::create("driver", this);
        monitor = aes_monitor::type_id::create("monitor", this);
        scoreboard = aes_scoreboard::type_id::create("scoreboard", this);
        sequencer = uvm_sequencer#(aes_transaction)::type_id::create("sequencer", this);

        if (!uvm_config_db#(virtual aes_if)::get(this, "", "vif", vif))
            `uvm_fatal("NOVIF", {"Virtual interface must be set for: ", get_full_name()})
    endfunction

    function void connect_phase(uvm_phase phase);
        driver.seq_item_port.connect(sequencer.seq_item_export);
        monitor.analysis_port.connect(scoreboard.transaction_analysis_port);
        monitor.rst_port.connect(scoreboard.rst_port);
    endfunction
    
endclass