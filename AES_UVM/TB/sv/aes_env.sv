//  Class: apb_master_env
//
class aes_env extends uvm_env;
    `uvm_component_utils(aes_env);

    aes_agent agent;
    func_cov fc;
    //  Group: Functions

    //  Constructor: new
    function new(string name = "aes_env", uvm_component parent);
        super.new(name, parent);
    endfunction: new

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        agent = aes_agent::type_id::create("agent", this);
        fc = func_cov::type_id::create("fc", this);
    endfunction: build_phase

    virtual function void connect_phase(uvm_phase phase);
        agent.monitor.mon_ap.connect(fc.analysis_export);
    endfunction: connect_phase

    function void start_of_simulation_phase(uvm_phase phase);
        `uvm_info(get_type_name(), {"start of simulation for ", get_full_name()}, UVM_HIGH)
    endfunction : start_of_simulation_phase
    
endclass: aes_env
