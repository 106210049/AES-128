
virtual class aes_base_sequence extends uvm_sequence #(aes_transaction);
    function new(string name = "aes_base_sequence");
        super.new(name);
    endfunction
endclass : aes_base_sequence
/// Plan Test for ENCRYPTION 
// Plan test 3
class aes_single_en extends aes_base_sequence;
        `uvm_object_utils(aes_single_en)
        aes_transaction req;
        function new(string name = "aes_single_en");
            super.new(name);
        endfunction
        task body();
            `uvm_info("aes_single_en", "Starting aes_single_en", UVM_LOW)
            repeat(1) begin
                req = aes_transaction::type_id::create("req");
                start_item(req);
                //$srandom(int'($time)); 
              void' (req.randomize() with {data_input == 128'h00112233445566778899aabbccddeeff ;
               key == 128'h000102030405060708090a0b0c0d0e0f;});
                finish_item(req);
            end
        endtask
endclass : aes_single_en
// plan test 4
class aes_multi_en extends aes_base_sequence;
    `uvm_object_utils(aes_multi_en)
    aes_transaction req;
    function new(string name = "aes_multi_en");
        super.new(name);
    endfunction
    task body();
        `uvm_info("aes_multi_en", "Starting aes_multi_en", UVM_LOW)
        repeat(10) begin
            `uvm_do(req);
        end
    endtask
endclass : aes_multi_en

 // Plan test 5 
class aes_spec_case_en extends aes_base_sequence;
    `uvm_object_utils(aes_spec_case_en)
    aes_transaction req;
    
    // Khai báo mảng dữ liệu
    bit [127:0] data_inputs[4];
    bit [127:0] keys[4];

    function new(string name = "aes_spec_case_en");
        super.new(name);
        
        // Gán giá trị cho mảng
        data_inputs = '{
            128'h00000000000000000000000000000000,
            128'hFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF,
            128'hAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA,
            128'h55555555555555555555555555555555
        };

        keys = '{
            128'h00000000000000000000000000000000,
            128'hFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF,
            128'hAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA,
            128'h55555555555555555555555555555555
        };
    endfunction

    task body();
        `uvm_info("aes_spec_case_en", "Starting aes_spec_case_en", UVM_LOW)
        
        foreach (data_inputs[i]) begin
            req = aes_transaction::type_id::create("req");
            start_item(req);

            // Dùng void'() để tránh lỗi cú pháp
            void'(req.randomize() with {
                data_input == data_inputs[i];
                key == keys[i];
            });

            finish_item(req);
        end
    endtask
endclass : aes_spec_case_en

// Plan Test for DECRYPTION------------------------------------------------------------------------------------------------- 
// Plan 6 
class aes_single_de extends aes_base_sequence;
        `uvm_object_utils(aes_single_de)
        aes_transaction req;
        function new(string name = "aes_single_de");
            super.new(name);
        endfunction
        task body();
            `uvm_info("aes_single_de", "Starting aes_single_de", UVM_LOW)
            repeat(2) begin
                req = aes_transaction::type_id::create("req");
                start_item(req);
                //$srandom(int'($time)); 
              void'( req.randomize() with   {data_input == 128'h69c4e0d86a7b0430d8cdb78070b4c55a ;
               key == 128'h13111d7fe3944a17f307a78b4d2b30c5;});
                finish_item(req);
            end
        endtask
endclass : aes_single_de
// plan 7 

class aes_multi_de extends aes_base_sequence;
    `uvm_object_utils(aes_multi_de)
    aes_transaction req;
    function new(string name = "aes_multi_de");
        super.new(name);
    endfunction
    task body();
        `uvm_info("aes_multi_de", "Starting aes_multi_de", UVM_LOW)
        repeat(10) begin
            `uvm_do(req);
        end
    endtask
endclass : aes_multi_de

//plan 8 
class aes_spec_case_de extends aes_base_sequence;
    `uvm_object_utils(aes_spec_case_de)
    aes_transaction req;
    
    // Khai báo mảng dữ liệu
    bit [127:0] data_inputs[4];
    bit [127:0] keys[4];

    function new(string name = "aes_spec_case_de");
        super.new(name);
        
        // Gán giá trị cho mảng
        data_inputs = '{
            128'h00000000000000000000000000000000,
            128'hFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF,
            128'hAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA,
            128'h55555555555555555555555555555555
        };

        keys = '{
            128'h00000000000000000000000000000000,
            128'hFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF,
            128'hAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA,
            128'h55555555555555555555555555555555
        };
    endfunction

    task body();
        `uvm_info("aes_spec_case_de", "Starting aes_spec_case_de", UVM_LOW)
        
        foreach (data_inputs[i]) begin
            req = aes_transaction::type_id::create("req");
            start_item(req);

            // Dùng void'() để tránh lỗi cú pháp
            void'(req.randomize() with {
                data_input == data_inputs[i];
                key == keys[i];
            });

            finish_item(req);
        end
    endtask
endclass : aes_spec_case_de