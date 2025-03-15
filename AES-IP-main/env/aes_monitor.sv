
class aes_monitor extends uvm_monitor;
    `uvm_component_utils(aes_monitor)
 
    virtual aes_if vif;  // Interface kết nối với DUT
    uvm_analysis_port#(aes_transaction) analysis_port;  // Analysis port để gửi transaction
    uvm_analysis_port#(logic) rst_port;  // Analysis port để gửi reset signal
    int count;  // count the number of clock cycles before finished is activated
    bit finished_flag = 0;
    logic rst;
    aes_transaction trans;
    function new(string aes_monitor = "aes_monitor", uvm_component parent = null);
       super.new(aes_monitor, parent);
       analysis_port = new("analysis_port", this);
        rst_port = new("rst_port", this);
    endfunction

    function void build_phase(uvm_phase phase);
       if (!uvm_config_db#(virtual aes_if)::get(this, "", "vif", vif))
          `uvm_fatal(get_type_name(), "Interface not set in config DB");
    endfunction
 
    task run_phase(uvm_phase phase);
       
       fork
            detect_reset();
            colect_send_data();
            check_finish_signal();
       join
    endtask

    task detect_reset();
        forever begin
            @(posedge vif.clk);
            if(vif.rst_n == 0) begin
                `uvm_info(get_type_name(), "Reset signal is asserted", UVM_LOW);
                rst_port.write(vif.rst_n);
            end
            else begin
                rst_port.write(vif.rst_n);
            end
        end
    endtask

    task colect_send_data();
        forever begin
            if(this.count ==0 && vif.rst_n == 1)  begin
            `uvm_info(get_type_name(), "Collecting data", UVM_LOW);
            
            trans = aes_transaction::type_id::create("trans");
            trans.data_input = vif.data_input;
            trans.key = vif.key;
            
            @(posedge vif.clk);
            wait(this.finished_flag == 1);
            trans.data_output = vif.data_output;
            `uvm_info(get_type_name(), $sformatf("Send transaction to scb: in[%2h], key[%2h], out[%2h]", trans.data_input,trans.key, trans.data_output), UVM_LOW);
            analysis_port.write(trans);  
            end
            else begin
                @(posedge vif.clk);
            end
        end
    endtask

    task check_finish_signal();
        forever begin
            @(posedge vif.clk);
            
            if( vif.finished ==1 && vif.rst_n == 1) begin
                if(this.count != 10) begin
                    this.finished_flag = 0;
                    this.count = 0;
                end 
                else begin
                    this.count = 0;
                    this.finished_flag = 1;
                    `uvm_info(get_type_name(), "Finished signal is asserted", UVM_LOW);
                end
            end
            else if(vif.rst_n == 1 && vif.finished == 0)begin
                this.count++;
                this.finished_flag = 0;
            end
            else begin
                this.count = 0;
                this.finished_flag = 0;
            end
        end
    endtask
 endclass
 