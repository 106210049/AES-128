//  Class: aes_sequence_item
//
class aes_sequence_item extends uvm_sequence_item;
   
    rand bit [127:0]    data_in;
    rand bit [127:0]    key;
    bit      [127:0]    data_out;
    bit                 finished;

    `uvm_object_utils_begin(aes_sequence_item)
        `uvm_field_int(data_in, UVM_ALL_ON + UVM_HEX)
        `uvm_field_int(key, UVM_ALL_ON + UVM_HEX)
        `uvm_field_int(data_out, UVM_ALL_ON + UVM_HEX)
        `uvm_field_int(finished,  UVM_ALL_ON + UVM_BIN)
    `uvm_object_utils_end
    
    //  Group: Functions

    //  Constructor: new
    function new(string name = "aes_sequence_item");
        super.new(name);
    endfunction: new



/*----------------------------------------------------------------------------*/
/*  Constraints                                                               */
/*----------------------------------------------------------------------------*/
constraint data_in_c { data_in inside {[128'h0:128'hFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF]}; }
constraint key_c { key inside {[128'h0:128'hFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF]}; }



/*----------------------------------------------------------------------------*/
/*  Functions                                                                 */
/*----------------------------------------------------------------------------*/

endclass: aes_sequence_item
