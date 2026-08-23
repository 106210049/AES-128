//  Class: aes_driver
//
class aes_driver extends uvm_driver #(aes_sequence_item);
    `uvm_component_utils(aes_driver);

    int num_pkg_sent;
    virtual interface aes_if vif;

    //  Group: Functions

    //  Constructor: new
    function new(string name = "aes_driver", uvm_component parent);
        super.new(name, parent);
    endfunction: new

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
    endfunction: build_phase

    function void connect_phase(uvm_phase phase);
        if(!aes_vif_config::get(this, "", "vif", vif))
            `uvm_error(get_type_name(), $sformatf("virtual interface must be set for: %s vif", get_full_name()))
        else 
            `uvm_info(get_type_name(), "Driver is connected with interface", UVM_HIGH)
    endfunction: connect_phase

     function void start_of_simulation_phase(uvm_phase phase);
        `uvm_info(get_type_name(), {"start of simulation for ", get_full_name()}, UVM_HIGH)
    endfunction : start_of_simulation_phase
    
    task run_phase(uvm_phase phase);
        `uvm_info(get_type_name(),$sformatf("Driver is running"), UVM_LOW);
        fork
            begin
                @(negedge vif.rst_n)
                @(posedge vif.rst_n);
                `uvm_info(get_type_name(), "Reset dropped", UVM_MEDIUM)
                forever begin
                    // Get new item from the sequencer
                    seq_item_port.get_next_item(req);
                    // Send the item to DUT
                    send_packet(req);
                    // Communicate item done to the sequencer
                    seq_item_port.item_done();
                end
            end
            reset_signals();
        join
    endtask: run_phase

    task send_packet(aes_sequence_item aes_pkt);
        `uvm_info(get_type_name(), $sformatf("Sending Packet :\n%s", aes_pkt.sprint()), UVM_HIGH)
        fork
            begin
               vif.send_to_dut(aes_pkt.data_in, aes_pkt.key);
            end
            @(posedge vif.drvstart) void'(begin_tr(req, "Driver_AES"));
        join
        end_tr(req);
        num_pkg_sent++;
    endtask: send_packet

    task reset_signals();
        vif.aes_reset();
    endtask: reset_signals
    
endclass: aes_driver
