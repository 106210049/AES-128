interface aes_if;
    logic clk;
    logic rst_n;
    logic [127:0] data_input;
    logic [127:0] key;
    logic [127:0] data_output;
    logic finished;
endinterface