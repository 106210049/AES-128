class aes_test_definetion_dec extends aes_base_test;
    `uvm_component_utils(aes_test_definetion_dec)
    aes_single_de aes_seq_de;
    function new(string name = "aes_test_definetion_dec", uvm_component parent = null);
        super.new(name, parent);
    endfunction
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
    aes_seq_de = aes_single_de::type_id::create("aes_seq_de");
    endfunction
    task run_phase(uvm_phase phase);
        `uvm_info(get_type_name(), "Starting test", UVM_LOW)
        super.run_phase(phase);
        phase.raise_objection(this);
        aes_seq_de.start(aes_env0.sequencer);
        phase.drop_objection(this);
    endtask
endclass : aes_test_definetion_dec
