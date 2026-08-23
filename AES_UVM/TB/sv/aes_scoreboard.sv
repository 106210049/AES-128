// Định nghĩa DPI đặt ngoài class
import "DPI-C" function void AES128_ECB_encrypt_dpi(
    input  bit [127:0] data_in,
    input  bit [127:0] key,
    output bit [127:0] data_out
);

import "DPI-C" function void AES128_ECB_decrypt_dpi(
    input  bit [127:0] data_in,
    input  bit [127:0] key,
    output bit [127:0] data_out
);

class aes_scoreboard extends uvm_scoreboard;
  `uvm_component_utils(aes_scoreboard)

  typedef enum bit {EQUALITY, UVM} comp_t;
  comp_t compare_policy = EQUALITY;

  `uvm_analysis_imp_decl(_exp)
  `uvm_analysis_imp_decl(_act)

  uvm_analysis_imp_exp #(aes_sequence_item, aes_scoreboard) exp_imp;
  uvm_analysis_imp_act #(aes_sequence_item, aes_scoreboard) act_imp;

  aes_sequence_item exp_queue[$];
  aes_sequence_item act_queue[$];

  int packets_in, packets_out, pass_count, fail_count;

  function new(string name="aes_scoreboard", uvm_component parent);
    super.new(name, parent);
    exp_imp = new("exp_imp", this);
    act_imp = new("act_imp", this);
  endfunction

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

  function void write_exp(aes_sequence_item pkt);
    aes_sequence_item scb_pkt;
    `uvm_info(get_type_name(),
      $sformatf("Expected queued:\n%s", pkt.sprint()), UVM_HIGH)
    $cast(scb_pkt, pkt.clone());
    packets_in++;
    exp_queue.push_back(scb_pkt);
    // `uvm_info(get_type_name(),
    //   $sformatf("Expected queued:\n%s", scb_pkt.sprint()), UVM_HIGH)
  endfunction

  function void write_act(aes_sequence_item pkt);
    aes_sequence_item scb_pkt;
    `uvm_info(get_type_name(),
      $sformatf("Actual queued:\n%s", pkt.sprint()), UVM_HIGH)
    $cast(scb_pkt, pkt.clone());
    packets_out++;
    act_queue.push_back(scb_pkt);
    // `uvm_info(get_type_name(),
    //   $sformatf("Actual queued:\n%s", scb_pkt.sprint()), UVM_HIGH)
  endfunction

  function void check_phase(uvm_phase phase);
    aes_sequence_item exp_pkt, act_pkt;
    bit [127:0] exp_result;
    while(exp_queue.size()>0 && act_queue.size()>0) begin
      exp_pkt = exp_queue.pop_front();
      act_pkt = act_queue.pop_front();

      exp_result = golden_model(exp_pkt.data_in, exp_pkt.key);

      case(compare_policy)
        EQUALITY: begin
          if(act_pkt.data_out === exp_result) begin
            pass_count++;
            `uvm_info(get_type_name(),
              $sformatf("MATCH: DUT_out=%h REF_out=%h", act_pkt.data_out, exp_result),
              UVM_MEDIUM)
          end else begin
            fail_count++;
            `uvm_error(get_type_name(),
              $sformatf("MISCOMPARE: DUT_out=%h REF_out=%h", act_pkt.data_out, exp_result))
          end
        end
        UVM: begin
          if(exp_pkt.compare(act_pkt)) begin
            pass_count++;
            `uvm_info(get_type_name(),"MATCH via compare()", UVM_MEDIUM)
          end else begin
            fail_count++;
            `uvm_error(get_type_name(),
              $sformatf("MISCOMPARE via compare()\nEXP:\n%s\nACT:\n%s",
                        exp_pkt.sprint(), act_pkt.sprint()))
          end
        end
      endcase
    end
  endfunction

  function void report_phase(uvm_phase phase);
    `uvm_info(get_type_name(),
      $sformatf("AES Scoreboard summary: in=%0d out=%0d pass=%0d fail=%0d",
                packets_in, packets_out, pass_count, fail_count),
      UVM_LOW)
      if (fail_count > 0)
            `uvm_error(get_type_name(),"Status:\n\nSimulation FAILED\n")
        else
            `uvm_info(get_type_name(),"Status:\n\nSimulation PASSED\n", UVM_NONE)
  endfunction
endclass: aes_scoreboard
