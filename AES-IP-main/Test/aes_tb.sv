`include "design.sv"
`include "aes_if.sv"
`include "aes_pkg.sv"
module aes_tb;
    import uvm_pkg::*;
    import aes_pkg::*;
    `include "uvm_macros.svh"

    aes_if vif();
    AES_CORE dut(
        .clk(vif.clk),
        .rst_n(vif.rst_n),
        .data_in(vif.data_input),
        .key(vif.key),
        .data_out(vif.data_output),
        .finished(vif.finished)
    );

    initial begin
        uvm_config_db#(virtual aes_if)::set(null, "*", "vif", vif);
        run_test("aes_test_definetion_enc");
        //run_test("aes_test_special_data_enc");
        //run_test("aes_test_continuous_enc");

        //run_test("aes_test_definetion_dec");
        //run_test("aes_test_continuous_dec");
       // run_test("aes_test_special_data_dec");
        
    end
    initial 
    begin
        vif.rst_n <= 1'b0;
        vif.clk <= 1'b1;
        #18 vif.rst_n = 1'b1;
       //#50 vif.rst_n = 1'b0;
       // #100 vif.rst_n = 1'b1;
        // #150 vif.rst_n = 1'b0;
        // #200 vif.rst_n = 1'b1;
        // #250 vif.rst_n = 1'b0;
       
    end
    
      //Generate Clock
    always
        #5 vif.clk = ~vif.clk;
endmodule