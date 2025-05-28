SET PARAllel Option -threads 1,4 -norelease_license
SET COmpare Options -threads 1,4
SET MUltiplier Implementation boothrca -both
SET UNDEfined Cell black_box -noascend -both
ADD SEarch Path /home/DN03/LIBS/lib/max -library -both
REAd LIbrary -liberty -both /home/DN03/AES128/LIBS/lib/max/leon.lib /home/DN03/AES128/LIBS/lib/max/MEM1_1024X32_slow.lib\
   /home/DN03/AES128/LIBS/lib/max/MEM1_256X32_slow.lib /home/DN03/AES128/LIBS/lib/max/MEM1_4096X32_slow.lib\
   /home/DN03/AES128/LIBS/lib/max/MEM2_1024X32_slow.lib /home/DN03/AES128/LIBS/lib/max/MEM2_128X16_slow.lib\
   /home/DN03/AES128/LIBS/lib/max/MEM2_128X32_slow.lib /home/DN03/AES128/LIBS/lib/max/MEM2_136X32_slow.lib\
   /home/DN03/AES128/LIBS/lib/max/MEM2_2048X32_slow.lib /home/DN03/AES128/LIBS/lib/max/MEM2_4096X32_slow.lib\
   /home/DN03/AES128/LIBS/lib/max/MEM2_512X32_slow.lib /home/DN03/AES128/LIBS/lib/max/pllclk_slow.lib\
   /home/DN03/AES128/LIBS/lib/max/pdkIO.lib /home/DN03/AES128/LIBS/lib/max/fast_vdd1v2_basicCells.lib
REAd DEsign -verilog95 -golden -lastmod -noelab /home/DN03/COUNTER/OUTPUT/counter_netlist.v
ELAborate DEsign -golden -root counter
REAd DEsign -verilog95 -revised -lastmod -noelab /home/DN03/COUNTER/OUTPUT/counter.map.v
ELAborate DEsign -revised -root counter
REPort DEsign Data
REPort BLack Box
SET FLatten Model -seq_constant
SET FLatten Model -seq_constant_x_to 0
SET FLatten Model -nodff_to_dlat_zero
SET FLatten Model -nodff_to_dlat_feedback
SET FLatten Model -hier_seq_merge
SET FLatten Model -gated_clock
SET ANalyze Option -auto -report_map
SET SYstem Mode lec
REPort UNmapped Points -summary
REPort UNmapped Points -notmapped
ADD COmpared Points -all
COMpare
REPort COmpare Data -class nonequivalent -class abort -class notcompared
REPort VErification -verbose
REPort STatistics
WRIte COmpared Points noneq.compared_points.counter.write_lec_generate_label.1.countermapv.tcl -class noneq\
   -tclmode -replace
ANAlyze NOnequivalent -source_diagnosis
REPort NOnequivalent Analysis
REPort TEst Vector -noneq
WRIte VErification Information
REPort VErification Information
EXIt -f
