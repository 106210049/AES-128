`timescale 1ns/1ns

interface aes_if
(
    input bit clk,
    input bit rst_n
);
    logic [127:0] data_in;
    logic [127:0] key;
    logic [127:0] data_out;
    logic finished;

    modport aes_core (
        input clk,
        input rst_n,
        input data_in,
        input key,
        output data_out,
        output finished
    );

    bit drvstart, monstart;

    task aes_reset();
        @(negedge rst_n);
        data_in <= '0;
        key <= '0;
    endtask: aes_reset

    task send_to_dut(
        input   bit [127:0] data_input,
                bit [127:0] key_input
    );
        wait (finished == 1 && rst_n == 1);
        #0;
        drvstart = 1;
        data_in <= data_input;
        key <= key_input;
        @(posedge finished)
        drvstart = 0;
    endtask: send_to_dut

    task collect_input(
        output  bit [127:0] input_data,
                bit [127:0] input_key,
                bit [127:0] data_output
    );
        `ifdef CIPHER    
        @(negedge tb_aes_top.uut.u_cipher_top.begin_round);
        `else 
        @(negedge tb_aes_top.uut.u_decipher_top.begin_round);
        `endif
        monstart = 1;
        input_data = data_in;
        input_key = key;
        data_output = data_out;
        @(posedge clk);
        monstart = 0;
    endtask: collect_input

    task collect_output(
        output  bit [127:0] data_output,
                bit [127:0] input_data,
                bit [127:0] input_key
    );
        @(posedge finished iff rst_n);
        monstart = 1;
        input_data = data_in;
        input_key = key;
        data_output = data_out;
        @(posedge clk);
        monstart = 0;
    endtask: collect_output
    
endinterface: aes_if
