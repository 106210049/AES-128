class aes_test_continuous_dec extends aes_base_test;
    `uvm_component_utils(aes_test_continuous_dec)
    aes_multi_de aes_mul_seq_de;
    function new(string name = "aes_test_continuous_dec", uvm_component parent = null);
        super.new(name, parent);
    endfunction
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
    aes_mul_seq_de = aes_multi_de::type_id::create("aes_mul_seq_de");
    endfunction
    task run_phase(uvm_phase phase);
        `uvm_info(get_type_name(), "Starting test", UVM_LOW)
        super.run_phase(phase);
        phase.raise_objection(this);
        aes_mul_seq_de.start(aes_env0.sequencer);
        phase.drop_objection(this);
    endtask
endclass : aes_test_continuous_dec
