
class aes_transaction extends uvm_sequence_item;
  `uvm_object_utils(aes_transaction)
    
    rand bit [127:0] data_input;
    rand bit [127:0] key;
    logic [127:0] data_output;

    function new(string name = "aes_transaction");
      super.new(name);
    endfunction
    
endclass : aes_transaction