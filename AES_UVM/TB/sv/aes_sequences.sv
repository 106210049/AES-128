//  Class: aes_sequences
//
class aes_sequences extends uvm_sequence #(aes_sequence_item);
    `uvm_object_utils(aes_sequences);

    //  Group: Functions

    //  Constructor: new
    function new(string name = "aes_sequences");
        super.new(name);
    endfunction: new

    task pre_body();
        uvm_phase phase;
        `ifdef UVM_VERSION_1_2
            phase = get_starting_phase();
        `else 
            phase = starting_phase;
        `endif
        if(phase != null) begin
            // Raise objection to prevent the run_phase from ending before the sequence is complete
            phase.raise_objection(this, get_type_name());
            `uvm_info(get_type_name(), "raise objection", UVM_MEDIUM)
        end
    endtask: pre_body

    task post_body();
        uvm_phase phase;
        `ifdef UVM_VERSION_1_2
            phase = get_starting_phase();
        `else 
            phase = starting_phase;
        `endif
        if(phase != null) begin
            // Drop objection để cho phép run_phase kết thúc
            phase.drop_objection(this, get_type_name());
            `uvm_info(get_type_name(), "drop objection", UVM_MEDIUM)

            // Thêm drain time 100ns để chờ các giao dịch còn lại
            phase.phase_done.set_drain_time(this, 100ns);
            `uvm_info(get_type_name(), "set drain time 100ns", UVM_MEDIUM)
            uvm_test_done.stop_request();
        end
    endtask: post_body


endclass: aes_sequences

class aes_data_zero_sequences extends aes_sequences;
    `uvm_object_utils(aes_data_zero_sequences);

    function new(string name = "aes_data_zero_sequences");
        super.new(name);
    endfunction: new

    task body();
        `uvm_info(get_type_name(), "Executing aes_data_zero_sequences", UVM_LOW)
        `uvm_do_with(req, {req.data_in == 128'h0;})
    endtask: body
endclass: aes_data_zero_sequences


class aes_key_zero_sequences extends aes_sequences;
    `uvm_object_utils(aes_key_zero_sequences);

    function new(string name = "aes_key_zero_sequences");
        super.new(name);
    endfunction: new

    task body();
        `uvm_info(get_type_name(), "Executing aes_key_zero_sequences", UVM_LOW)
        `uvm_do_with(req, {req.key == 128'h0;})
    endtask: body
endclass: aes_key_zero_sequences

class aes_data_all_one_sequences extends aes_sequences;
    `uvm_object_utils(aes_data_all_one_sequences);

    function new(string name = "aes_data_all_one_sequences");
        super.new(name);
    endfunction: new

    task body();
        `uvm_info(get_type_name(), "Executing aes_data_all_one_sequences", UVM_LOW)
        `uvm_do_with(req, {req.data_in == 128'hFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;})
    endtask: body
endclass: aes_data_all_one_sequences

class aes_key_all_one_sequences extends aes_sequences;
    `uvm_object_utils(aes_key_all_one_sequences);

    function new(string name = "aes_key_all_one_sequences");
        super.new(name);
    endfunction: new

    task body();
        `uvm_info(get_type_name(), "Executing aes_key_all_one_sequences", UVM_LOW)
        `uvm_do_with(req, {req.key == 128'hFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;})
    endtask: body
endclass: aes_key_all_one_sequences

class aes_random_sequences extends aes_sequences;
    `uvm_object_utils(aes_random_sequences);

    function new(string name = "aes_random_sequences");
        super.new(name);
    endfunction: new

    task body();
        `uvm_info(get_type_name(), "Executing aes_random_sequences", UVM_LOW)
        `uvm_do(req)
    endtask: body
endclass: aes_random_sequences

class aes_random_5_sequences extends aes_sequences;
`uvm_object_utils(aes_random_5_sequences);

    function new(string name = "aes_random_5_sequences");
        super.new(name);
    endfunction: new

    task body();
        `uvm_info(get_type_name(), "Executing aes_random_5_sequences", UVM_LOW)
        repeat(5)
            `uvm_do(req)
    endtask: body
endclass: aes_random_5_sequences