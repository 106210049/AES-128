//  Class: aes_sequencer
//
class aes_sequencer extends uvm_sequencer #(aes_sequence_item);
    `uvm_component_utils(aes_sequencer);

    //  Constructor: new
    function new(string name = "aes_sequencer", uvm_component parent);
        super.new(name, parent);
    endfunction: new

    function void start_of_simulation_phase(uvm_phase phase);
        super.start_of_simulation_phase(phase);
    endfunction: start_of_simulation_phase
    
endclass: aes_sequencer
