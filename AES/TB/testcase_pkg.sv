package testcase_pkg;
    typedef enum logic [2:0] {
        RANDOM_TEST             = 3'b000,
        `ifdef DECIPHER
        DECRYPT                 = 3'b001,
        MID_RESET_DECRYPT       = 3'b010,
        `else
        ENCRYPT                 = 3'b011,
        MID_RESET_ENCRYPT       = 3'b100,
        `endif
        STABLE_PROCESS          = 3'b101
    } test_case;
   
endpackage