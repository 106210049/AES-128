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
    
endinterface
