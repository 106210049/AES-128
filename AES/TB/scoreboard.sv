class scoreboard;

  mailbox mon_to_scb;
  transaction tr;

  int compare_cnt;
  int pass_cnt;
  int fail_cnt;

  function new(mailbox mon_to_scb);
    this.mon_to_scb   = mon_to_scb;
    this.compare_cnt = 0;
    this.pass_cnt    = 0;
    this.fail_cnt    = 0;
  endfunction

  // Golden model: chuyển bit[127:0] sang byte[16] bằng streaming operator
  function bit [127:0] golden_model(
    bit [127:0] data,
    bit [127:0] key
  );

    bit [127:0] data_bytes;
    bit [127:0] key_bytes;
    bit [127:0] result_bytes;
    bit [127:0] c_result;

    // Chuyển packed vector thành mảng byte theo thứ tự MSB -> LSB
    data_bytes = {<<8{data}};
    key_bytes  = {<<8{key}};

    `ifdef DECIPHER
      AES128_ECB_decrypt_dpi(data_bytes, key_bytes, result_bytes);
      $display("[SCB] Golden Model: Data=%032h Key=%032h Result=%032h",
               data, key, {<<8{result_bytes}});
    `else
      AES128_ECB_encrypt_dpi(data_bytes, key_bytes, result_bytes);
      $display("[SCB] Golden Model: Data=%032h Key=%032h Result=%032h",
               data, key, {<<8{result_bytes}});
    `endif

    // Pack lại mảng byte thành bit[127:0] để trả về
    c_result = {<<8{result_bytes}};
    return c_result;

  endfunction

  task run();

    bit [127:0] exp_result;

    forever begin
      mon_to_scb.get(tr);
      compare_cnt++;

      exp_result = golden_model(tr.data_in, tr.key);

      if (tr.data_out !== exp_result) begin
        fail_cnt++;
        $display("[SCB][ERROR] %0t: Mismatch!", $time);
        $display("  Compare ID : %0d", compare_cnt);
        $display("  Data       : %h", tr.data_in);
        $display("  Key        : %h", tr.key);
        $display("  Data Out   : %h", tr.data_out);
        $display("  REF_out    : %h", exp_result);
      end
      else begin
        pass_cnt++;
        $display("[SCB][PASS] %0t: Match!", $time);
        $display("  Compare ID : %0d", compare_cnt);
        $display("  Data       : %h", tr.data_in);
        $display("  Key        : %h", tr.key);
        $display("  Data Out   : %h", tr.data_out);
        $display("  REF_out    : %h", exp_result);
      end
    end

  endtask

  function void report();
    $display("========================================");
    $display("[SCB] AES Scoreboard Report");
    $display("  Total compare : %0d", compare_cnt);
    $display("  PASS          : %0d", pass_cnt);
    $display("  FAIL          : %0d", fail_cnt);
    $display("========================================");
  endfunction

endclass
