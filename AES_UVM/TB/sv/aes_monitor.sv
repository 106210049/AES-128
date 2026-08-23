//  Class: aes_monitor
//
class aes_monitor extends uvm_component;
    `uvm_component_utils(aes_monitor);

    int num_pkt_col;

    uvm_analysis_port #(aes_sequence_item) exp_ap;
    uvm_analysis_port #(aes_sequence_item) mon_ap;
    virtual interface aes_if vif;

    //  Constructor: new
    function new(string name = "aes_monitor", uvm_component parent);
        super.new(name, parent);
        exp_ap = new("exp_ap", this);
        mon_ap = new("mon_ap", this);
    endfunction: new

    function void connect_phase(uvm_phase phase);
        if(!aes_vif_config::get(this, "", "vif", vif))
            `uvm_error(get_type_name(),
                $sformatf("virtual interface must be set for: %s vif", get_full_name()))
    endfunction

    function void start_of_simulation_phase(uvm_phase phase);
        `uvm_info(get_type_name(),
            {"start of simulation for ", get_full_name()}, UVM_HIGH)
    endfunction

    task run_phase(uvm_phase phase);
        @(negedge vif.rst_n)
        @(posedge vif.rst_n);
        `uvm_info(get_type_name(), "Detected Reset Done", UVM_MEDIUM)

        forever begin
            aes_sequence_item exp_pkt;
            aes_sequence_item act_pkt;

            fork 
                // Collect expected packet (input side)
                begin
                    exp_pkt = aes_sequence_item::type_id::create("exp_pkt", this);
                    vif.collect_input(exp_pkt.data_in, exp_pkt.key, exp_pkt.data_out);
                    `uvm_info(get_type_name(), 
                        $sformatf("Monitor sent exp_pkt to scoreboard: \n%s", exp_pkt.sprint()), UVM_HIGH)
                    exp_ap.write(exp_pkt);
                end

                // Collect actual packet (output side)
                begin
                    act_pkt = aes_sequence_item::type_id::create("act_pkt", this);
                    vif.collect_output(act_pkt.data_out, act_pkt.data_in, act_pkt.key);
                    `uvm_info(get_type_name(), 
                        $sformatf("Monitor sent act_pkt to scoreboard: \n%s", act_pkt.sprint()), UVM_HIGH)
                    mon_ap.write(act_pkt);

                    // @(posedge vif.monstart)
                    // void'(begin_tr(act_pkt, "Monitor_AES"));    
                end
            join
            // end_tr(act_pkt);

            `uvm_info(get_type_name(), 
                $sformatf("Packet Collected: Input: \n%s, Output: \n%s", exp_pkt.sprint(), act_pkt.sprint()), UVM_LOW)

            num_pkt_col++;
        end
    endtask: run_phase

    function void report_phase(uvm_phase phase);
        `uvm_info(get_type_name(),
            $sformatf("Report: AES Monitor observed %0d transactions", num_pkt_col),
            UVM_LOW)
        if(num_pkt_col == 0)
            `uvm_error(get_type_name(), "No packets observed")
    endfunction
    
endclass: aes_monitor
