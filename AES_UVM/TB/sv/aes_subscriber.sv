virtual class uvm_subscriber #(type T=int) extends uvm_component;

  typedef uvm_subscriber #(T) this_type;
  uvm_analysis_imp #(T, this_type) analysis_export;
  
  function new (string name, uvm_component parent);
    super.new(name, parent);
    analysis_export = new("analysis_imp", this);
  endfunction
  
  pure virtual function void write(T t);
endclass: uvm_subscriber

class func_cov extends uvm_subscriber #(aes_sequence_item);
    `uvm_component_utils(func_cov);
    bit [127:0] data_in;
    bit [127:0] key;

    covergroup cov_aes;
        cp_data_in: coverpoint data_in {
            bins zero = {128'h0};
            bins random = {[128'h0:128'hFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF]};
            bins one = {128'hFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF};
        }
        cp_key_in: coverpoint key {
            bins zero = {128'h0};
            bins random = {[128'h0:128'hFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF]};
            bins one = {128'hFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF};
        }
    endgroup: cov_aes

     function new(string name = "func_cov", uvm_component parent);
        super.new(name, parent);
        cov_aes = new();
    endfunction

    function void write(aes_sequence_item t);
        // Gán từ transaction sang biến mirror
        data_in  = t.data_in;
        key  = t.key;
       
        // Sample covergroups
        cov_aes.sample();
        
    endfunction
    
endclass: func_cov