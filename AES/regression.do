# regression.do

# đọc biến môi trường hoặc file cấu hình ngoài
if {[info exists ::env(MACRO)]} {
    set MACRO_LIST [split $::env(MACRO)]
    puts ">>> Đang chạy với define từ biến môi trường: $MACRO_LIST"
} elseif {[file exists defines.tcl]} {
    source defines.tcl
    puts ">>> Đang chạy với define từ defines.tcl: $MACRO_LIST"
} else {
    set MACRO_LIST {}
    puts ">>> Đang chạy không có define nào"
}

# Compile DPI-C nếu có
if {[file exists ./TB/aes.c]} {
    file delete -force build/aes.dll
    file delete -force build/aes.o
    set gcc "C:/msys64/ucrt64/bin/gcc.exe"
    file mkdir build

    # chú ý đường dẫn include dạng /c/... cho MSYS
    exec "C:/msys64/ucrt64/bin/gcc.exe" -c -fPIC -IC:/questasim64_10.7c/include ./TB/aes.c -o build/aes.o
    exec "C:/msys64/ucrt64/bin/gcc.exe" -shared -o build/aes.dll build/aes.o
}

# dọn dẹp logs cũ
if {[file exists logs]} {
    foreach f [glob -nocomplain -directory logs *] {
        file delete -force $f
    }
    file delete -force logs
}
file mkdir logs

# xóa file coverage tổng hợp cũ nếu có
file delete -force all_tests.ucdb

# danh sách các test cần chạy tùy theo macro
set TESTS {}
if {[lsearch -exact $MACRO_LIST "DECIPHER"] >= 0} {
    set TESTS {RANDOM_TEST DECRYPT MID_RESET_DECRYPT STABLE_PROCESS}
} else {
    set TESTS {RANDOM_TEST ENCRYPT MID_RESET_ENCRYPT STABLE_PROCESS}
}

# build define options
set DEFINE_OPTIONS {}
foreach m $MACRO_LIST {
    lappend DEFINE_OPTIONS "+define+$m"
}

vlog +cover {*}$DEFINE_OPTIONS ./RTL/aes_top.sv ./TB/testbench.sv
# chạy từng test
foreach t $TESTS {
    transcript file logs/$t.log
    # thêm -sv_lib để load DLL
    vsim -c -coverage -sv_lib ./build/aes -voptargs=+acc work.tb_aes_core +TESTNAME=$t -onfinish final -do "run -all; coverage save -onexit $t.ucdb; quit -sim;" -debugDB
    transcript file ""
}

# merge tất cả coverage lại thành một file duy nhất
vcover merge all_tests.ucdb *.ucdb

if {[file exists all_tests.ucdb]} {
    vcover report -html -htmldir covhtmlreport all_tests.ucdb
} else {
    puts "Không tìm thấy file all_tests.ucdb để tạo báo cáo coverage!"
}

exit

