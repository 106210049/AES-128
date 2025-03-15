

`uvm_analysis_imp_decl(_frm_Monitor)
`uvm_analysis_imp_decl(_rst)

import "DPI-C" function void AES128_ECB_encrypt_dpi(input  bit[7:0] dataIn[16],
input  bit[7:0] key[16],
output bit[7:0] dataOut[16]);

import "DPI-C" function void AES128_ECB_decrypt_dpi(input  bit[7:0] dataIn[16],
input  bit[7:0] key[16],
output bit[7:0] dataOut[16]);
/*

class aes_scoreboard extends uvm_scoreboard;
    `uvm_component_utils(aes_scoreboard)
    
    uvm_analysis_imp_frm_Monitor#(aes_transaction, aes_scoreboard) transaction_analysis_port;
    uvm_analysis_imp_rst#(logic, aes_scoreboard) rst_port;

    logic rst_flag;
    int         error_cnt;
    bit [127:0] ref_ciphertext;
    bit [7:0] plaintext_bytes[16], key_bytes[16], ciphertext_bytes[16];

    function new(string name = "aes_scoreboard", uvm_component parent = null);
        super.new(name, parent);
    endfunction
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        transaction_analysis_port = new("transaction_analysis_port", this);
        rst_port = new("rst_port", this);
    endfunction
    
    function void write_rst(logic rst);
        if (!rst) begin
                rst_flag = 1;
            end
        else begin
                rst_flag = 0;
            end
        
    endfunction

    function void write_frm_Monitor(aes_transaction trans);
        if(rst_flag == 1) begin
            `uvm_info(get_type_name(), "Reset signal is asserted", UVM_LOW);
            return;
        end
        else begin
            `uvm_info(get_type_name(), $sformatf("Received transaction: in[%2h], key[%2h], out[%2h] ", trans.data_input,trans.key, trans.data_output), UVM_LOW);

            foreach (plaintext_bytes[i]) begin
                plaintext_bytes[i] = trans.data_input[(15-i)*8 +: 8];
                key_bytes[i]       = trans.key[(15-i)*8 +: 8];
            end
            `ifdef CIPHER
                `uvm_info(get_type_name(), "Encrypting", UVM_LOW)
                AES128_ECB_encrypt_dpi( plaintext_bytes,key_bytes, ciphertext_bytes);
            `else
                `uvm_info(get_type_name(), "Decrypting", UVM_LOW)
                AES128_ECB_decrypt_dpi(plaintext_bytes,key_bytes, ciphertext_bytes);
            `endif
            foreach (ciphertext_bytes[i]) begin
                ref_ciphertext[(15-i)*8 +: 8] = ciphertext_bytes[i];
            end
            if (ref_ciphertext == trans.data_output) begin
            `uvm_info(get_type_name(),  $sformatf("Match: DUT=%h, REF=%h", trans.data_output, ref_ciphertext), UVM_MEDIUM)
            end 
            else begin
            `uvm_error(get_type_name(), $sformatf("Mismatch: DUT=%h, REF=%h", trans.data_output, ref_ciphertext))
            error_cnt++;
            end
        end
    endfunction
        
    function void report_phase(uvm_phase phase);
        super.report_phase(phase);
        `uvm_info(get_type_name(),$sformatf("***** ERROR_NUM = %0d *****", error_cnt), UVM_LOW)
        if(error_cnt != 0) 
            //simulation_top.test_fail();
            `uvm_error(get_type_name(), "Test failed")
        else 
            //simulation_top.test_pass();
            `uvm_info(get_type_name(), "Test passed", UVM_LOW)
    endfunction: report_phase
    
      
    
endclass
*/
class aes_scoreboard extends uvm_scoreboard;
    `uvm_component_utils(aes_scoreboard)
    
    uvm_analysis_imp_frm_Monitor#(aes_transaction, aes_scoreboard) transaction_analysis_port;
    uvm_analysis_imp_rst#(logic, aes_scoreboard) rst_port;
    string key_str;
    logic rst_flag;
    int         error_cnt;
    bit [127:0] ref_ciphertext;
    bit [7:0] plaintext_bytes[16], key_bytes[16], ciphertext_bytes[16];

    function new(string name = "aes_scoreboard", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        transaction_analysis_port = new("transaction_analysis_port", this);
        rst_port = new("rst_port", this);
    endfunction

    function void write_rst(logic rst);
        if (!rst) begin
            rst_flag = 1;
        end
        else begin
            rst_flag = 0;
        end
    endfunction

    function void write_frm_Monitor(aes_transaction trans);
        if (rst_flag == 1) begin
            `uvm_info(get_type_name(), "Reset signal is asserted, skipping transaction", UVM_LOW);
            return;
        end

        `uvm_info(get_type_name(), "----------------------------------------", UVM_LOW);
        `uvm_info(get_type_name(), "Received new transaction:", UVM_LOW);
        `uvm_info(get_type_name(), $sformatf("DUT Input Data  : %h", trans.data_input), UVM_LOW);
        `uvm_info(get_type_name(), $sformatf("DUT Key         : %h", trans.key), UVM_LOW);
        `uvm_info(get_type_name(), $sformatf("DUT Output Data : %h", trans.data_output), UVM_LOW);

        foreach (plaintext_bytes[i]) begin
            
            plaintext_bytes[i] = trans.data_input[(15-i)*8 +: 8];
            key_bytes[i]       = trans.key[(15-i)*8 +: 8];
        end

        `ifdef CIPHER
            `uvm_info(get_type_name(), "Performing Encryption...", UVM_LOW);
            AES128_ECB_encrypt_dpi(plaintext_bytes, key_bytes, ciphertext_bytes);
        `else
            `uvm_info(get_type_name(), "Performing Decryption...", UVM_LOW);
            AES128_ECB_decrypt_dpi(plaintext_bytes, key_bytes, ciphertext_bytes);

        `endif
          
        `uvm_info(get_type_name(), "Reference Model Output:", UVM_LOW);
        foreach (ciphertext_bytes[i]) begin
            ref_ciphertext[(15-i)*8 +: 8] = ciphertext_bytes[i];
        end

        `uvm_info(get_type_name(), $sformatf("Reference Output Data : %h", ref_ciphertext), UVM_LOW);

        if (ref_ciphertext == trans.data_output) begin
            `uvm_info(get_type_name(), $sformatf("MATCH: DUT=%h, REF=%h", trans.data_output, ref_ciphertext), UVM_MEDIUM);
        end 
        else begin
            `uvm_error(get_type_name(), $sformatf(" MISMATCH: DUT=%h, REF=%h", trans.data_output, ref_ciphertext));
            error_cnt++;
        end

        `uvm_info(get_type_name(), "----------------------------------------", UVM_LOW);
    endfunction
        
    function void report_phase(uvm_phase phase);
        super.report_phase(phase);
        `uvm_info(get_type_name(), $sformatf("***** ERROR COUNT = %0d *****", error_cnt), UVM_LOW);
        if (error_cnt != 0) begin
            `uvm_error(get_type_name(), "TEST FAILED ");
        end
        else begin
            `uvm_info(get_type_name(), "TEST PASSED ", UVM_LOW);
        end
    endfunction
endclass
