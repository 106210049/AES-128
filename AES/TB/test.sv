program test(aes_if vif);

  env env_o;
  // -----------------------------
  // Runtime params
  // -----------------------------
  string testname;
  int    timeout;

  initial begin
    `ifdef DECIPHER
    testname = "DECRYPT";
    `else 
    testname = "ENCRYPT";
    `endif
    timeout  = 3000;
    //----------------------------------------
    // Override via plusargs
    //----------------------------------------
    void'($value$plusargs("TESTNAME=%s", testname));
    void'($value$plusargs("TIMEOUT=%d", timeout));

    $display("[TEST] TESTNAME=%s TIMEOUT=%0d", testname, timeout);
    
    env_o = new(vif);

    case (testname)
      
      `ifdef DECIPHER
      "DECRYPT" : env_o.agt.cfg_gen(1, DECRYPT);
      "MID_RESET_DECRYPT": env_o.agt.cfg_gen(1, MID_RESET_DECRYPT);
      "RANDOM_TEST"     : env_o.agt.cfg_gen(10, RANDOM_TEST);
      "STABLE_PROCESS"    : env_o.agt.cfg_gen(1, STABLE_PROCESS);
      `else 
      "ENCRYPT" : env_o.agt.cfg_gen(1, ENCRYPT);
      "MID_RESET_ENCRYPT" : env_o.agt.cfg_gen(1, MID_RESET_ENCRYPT);
      "RANDOM_TEST"     : env_o.agt.cfg_gen(10, RANDOM_TEST);
      "STABLE_PROCESS"    : env_o.agt.cfg_gen(1, STABLE_PROCESS);
      `endif
      default: begin
        $display("[TEST][ERROR] Invalid TESTNAME=%s", testname);
        $finish;
      end
    endcase

    env_o.run();
    // #(timeout);
    wait(env_o.scb.compare_cnt >= env_o.agt.gen.num_gen);
    #50;
    //----------------------------------------
    // Report + Finish
    //----------------------------------------
    $display("[TEST] TIMEOUT reached");

    env_o.report();
    $finish;
  end

endprogram