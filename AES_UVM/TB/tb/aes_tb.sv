class aes_tb extends uvm_env;
    `uvm_component_utils(aes_tb);

    aes_env env;
    aes_scoreboard aes_scb;
    //  Constructor: new
    function new(string name = "aes_tb", uvm_component parent);
        super.new(name, parent);
    endfunction: new

    // Build Phase 
    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        env = aes_env::type_id::create("env", this);
        aes_scb = aes_scoreboard::type_id::create("aes_scb", this);
        `uvm_info(get_type_name(), $sformatf("Testbench Build Phase is being executed !"), UVM_HIGH)
    endfunction: build_phase

    function void connect_phase(uvm_phase phase);
        env.agent.monitor.exp_ap.connect(aes_scb.exp_imp);
        env.agent.monitor.mon_ap.connect(aes_scb.act_imp);
    endfunction: connect_phase

    function void start_of_simulation_phase(uvm_phase phase);
        `uvm_info(get_type_name(), {"start of simulation for ", get_full_name()}, UVM_HIGH)
    endfunction : start_of_simulation_phase
    
    task run_phase(uvm_phase phase);
        `uvm_info(get_type_name(), $sformatf("Testbench Run Phase is begin executed!"), UVM_LOW) 
    endtask: run_phase
endclass: aes_tb