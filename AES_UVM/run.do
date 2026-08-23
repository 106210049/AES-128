# regression_aes_uvm.do

# Setup paths
set uvm_path C:/questasim64_10.7c/verilog_src/uvm-1.1d/src
set wlf_dir ./wlf_out
set cov_dir ./cov_out
set log_dir ./logs

# Dọn dẹp thư mục cũ
foreach dir [list $wlf_dir $cov_dir $log_dir build] {
    if {[file exists $dir]} {
        foreach f [glob -nocomplain -directory $dir *] {
            file delete -force $f
        }
        file delete -force $dir
    }
    file mkdir $dir
}

# Xóa coverage tổng hợp cũ
file delete -force aes_all.ucdb

# Đọc macro từ biến môi trường hoặc file defines
if {[info exists ::env(MACRO)]} {
    set MACRO_LIST [split $::env(MACRO)]
    puts ">>> Đang chạy với define từ biến môi trường: $MACRO_LIST"
} elseif {[file exists defines.tcl]} {
    source defines.tcl
    puts ">>> Đang chạy với define từ defines.tcl: $MACRO_LIST"
} else {
    set MACRO_LIST {CIPHER}
    puts ">>> Không có macro, mặc định chạy CIPHER"
}

# Compile DPI-C nếu có
if {[file exists ./TB/aes.c]} {
    set gcc "C:/msys64/ucrt64/bin/gcc.exe"
    exec $gcc -c -fPIC -IC:/questasim64_10.7c/include ./TB/aes.c -o build/aes.o
    exec $gcc -shared -o build/aes.dll build/aes.o
}

# Build define options
set DEFINE_OPTIONS {}
foreach m $MACRO_LIST {
    lappend DEFINE_OPTIONS "+define+$m"
}

# Compile UVM package
vlog -sv +define+UVM_NO_DPI +incdir+$uvm_path $uvm_path/uvm_pkg.sv

# Compile AES project (gom RTL, TB, package, interface…)
vlog +cover -sv -svinputport=relaxed +incdir+$uvm_path {*}$DEFINE_OPTIONS -f ./TB/tb/aes_run.f

# Danh sách các test UVM tùy theo macro
set TESTS {}
if {[lsearch -exact $MACRO_LIST "DECIPHER"] >= 0} {
    set TESTS {aes_data_zero_test aes_key_zero_test aes_random_test aes_random_5_test aes_data_all_one_test aes_key_all_one_test}
} else {
    set TESTS {aes_data_zero_test aes_key_zero_test aes_random_test aes_random_5_test aes_data_all_one_test aes_key_all_one_test}
}

# Chạy từng test
foreach t $TESTS {
    set wlf_file "$wlf_dir/${t}.wlf"
    set ucdb_file "$cov_dir/${t}.ucdb"
    set log_file "$log_dir/${t}.log"

    puts ">>> Running test: $t"

    vsim -c -coverage -wlf $wlf_file work.tb_aes_top \
         -sv_lib ./build/aes \
         "+SVSEED=random" \
         "+UVM_TESTNAME=$t" \
         "+UVM_VERBOSITY=UVM_HIGH" \
         "+UVM_TR_RECORD" \
         -onfinish final \
         -do "transcript file $log_file; log -r /*; run -all; coverage save -onexit $ucdb_file; quit -sim;" \
         -debugDB
}

# Merge coverage
vcover merge aes_all.ucdb $cov_dir/*.ucdb

# Report coverage
if {[file exists aes_all.ucdb]} {
    # HTML report
    exec vcover report -html -htmldir covhtmlreport aes_all.ucdb

    # TXT report
    exec vcover report -detail -cvg -comments -output aes_cover_report.txt aes_all.ucdb

    # Hiển thị nội dung TXT ngay trong transcript
    set fp [open "aes_cover_report.txt" r]
    puts ">>> Nội dung coverage report:"
    puts [read $fp]
    close $fp
} else {
    puts "Không tìm thấy file aes_all.ucdb để tạo báo cáo coverage!"
}

exit
