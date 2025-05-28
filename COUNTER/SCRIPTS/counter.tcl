# set database for lib cell and hdl code
set_db init_lib_search_path /home/DN03/LIBS/lib/max
set_db init_hdl_search_path /home/DN03/COUNTER/RTL/
#============================
# Initial Settings
#============================
set_db design_process_node 45
set_db design_power_effort high
set_db hdl_preserve_unused_registers    false
set_db delete_unloaded_seqs 		true
set_db optimize_constant_0_flops        true
set_db optimize_constant_1_flops        true
set_db optimize_constant_latches        true

# Enable register optimization and retiming
set_db syn_global_effort high
set_db retime_effort_level high
set_db retime_optimize_reset true

# low, medium, high, express
set_db syn_generic_effort high
set_db syn_map_effort high
set_db syn_opt_effort high
set_db opt_area_recovery true
set_db opt_fix_fanout_load true
#set_db opt_area_recovery_setup_target_slack 0.05
#set_db opt_all_end_points true
#set_db opt_add_always_on_feed_through_buffers true

read_libs /home/DN03/AES128/LIBS/lib/max/leon.lib \
          /home/DN03/AES128/LIBS/lib/max/MEM1_1024X32_slow.lib \
          /home/DN03/AES128/LIBS/lib/max/MEM1_256X32_slow.lib \
          /home/DN03/AES128/LIBS/lib/max/MEM1_4096X32_slow.lib \
          /home/DN03/AES128/LIBS/lib/max/MEM2_1024X32_slow.lib \
          /home/DN03/AES128/LIBS/lib/max/MEM2_128X16_slow.lib \
          /home/DN03/AES128/LIBS/lib/max/MEM2_128X32_slow.lib \
          /home/DN03/AES128/LIBS/lib/max/MEM2_136X32_slow.lib \
          /home/DN03/AES128/LIBS/lib/max/MEM2_2048X32_slow.lib \
          /home/DN03/AES128/LIBS/lib/max/MEM2_4096X32_slow.lib \
          /home/DN03/AES128/LIBS/lib/max/MEM2_512X32_slow.lib \
	  /home/DN03/AES128/LIBS/lib/max/pllclk_slow.lib     \
          /home/DN03/AES128/LIBS/lib/max/pdkIO.lib \
          /home/DN03/AES128/LIBS/lib/max/fast_vdd1v2_basicCells.lib
#read_physical -lef {/home/DN03/PD_Work/Labs/Lab11.Route_2/LIBS/lef/gsclib045.fixed2.lef}
#===========================
# Read RTL and Elaborate
#===========================
# Read hdl code
read_hdl -language v2001 /home/DN03/COUNTER/RTL/counter.v

# Elaboration and Binding
elaborate
write_db -all_root_attributes /home/DN03/COUNTER/OUTPUT/outputs_counter/counter.elaborate.db

#===============================
# Setting for low power design
#===============================
set_db design:counter .lp_clock_gating_cell {}
set_db lp_insert_clock_gating true
set_db [get_lib_cells *ULVT*] .avoid true

#=============================
# Update instance/port names
#=============================
update_names -map {{"[" "_"} {"]" ""}} -inst -force
update_names -map {{"[" "_"} {"]" ""}} -port_bus
update_names -map {{"[" "_"} {"]" ""}} -hport_bus

#===============
# Set group
#===============
# Optional: Add path groups manually
define_cost_group -name in2reg  -design counter
define_cost_group -name reg2reg -design counter
define_cost_group -name reg2out -design counter
define_cost_group -name in2out  -design counter
set all_regs [get_cells -hierarchical -filter "is_sequential==true"]
path_group -from [all_inputs] -to $all_regs -group in2reg -name in2reg
path_group -from $all_regs -to $all_regs -group reg2reg -name reg2reg
path_group -from $all_regs -to [all_outputs] -group reg2out -name reg2out
path_group -from [all_inputs] -to [all_outputs] -group in2out -name in2out
# Read Synthesis Design Constraints

read_sdc /home/DN03/COUNTER/SDC/counter.sdc


#=========================
# Check design
#=========================
report_timing -lint -verbose > /home/DN03/COUNTER/REPORT/timing_lint.rpt
check_design  -all  >  /home/DN03/COUNTER/REPORT/check_design.rpt

#===============
# Generic
#===============
write_hdl -lec > /home/DN03/COUNTER/OUTPUT/counter.generic.v
write_sdc > /home/DN03/COUNTER/OUTPUT/counter.generic.sdc
write_db -all_root_attributes /home/DN03/COUNTER/OUTPUT/counter.generic.db

#Pre-mapping Optimization
syn_generic
set_db opt_fix_fanout_load true

# Technology Mapping
syn_map
#==============
# Map
#==============
write_hdl -lec > /home/DN03/COUNTER/OUTPUT/counter.map.v
write_sdc >  /home/DN03/COUNTER/OUTPUT/counter.map.sdc
write_db -all_root_attributes /home/DN03/COUNTER/OUTPUT/counter.map.db
write_do_lec -revised_design /home/DN03/COUNTER/OUTPUT/counter.map.v > ./wlec_rtltog1_dofile
#==============
# Post Opt
#==============
for {set i 0} {$i < 3} {incr i} {
  puts "Optimization round : $i"
  syn_opt
}

#Report timing
foreach cost_group [get_db cost_groups] {
  set base_name    [basename $cost_group]
  regsub -all {\/} $base_name "-" base_name
  report timing -cost_group [list $cost_group] -max_paths 200 > /home/DN03/COUNTER/REPORT/${base_name}.final.rpt
}

#report timing
report_timing -max_paths 100 > /home/DN03/COUNTER/REPORT/report_timing.rpt
#report power
report_power > /home/DN03/COUNTER/REPORT/report_power.rpt
#report area
report_area -detail > /home/DN03/COUNTER/REPORT/report_area.rpt
# report qor
report_qor > /home/DN03/COUNTER/REPORT/report_qor.rpt

# Outputs
write_db -all_root_attributes /home/DN03/COUNTER/OUTPUT/counter.final.db
# Create netlist
write_hdl -lec > /home/DN03/COUNTER/OUTPUT/counter_netlist.v
# Create SDC file
write_sdc > /home/DN03/COUNTER/OUTPUT/counter_sdc.sdc   
# Create do file for comformal check
write_do_lec -golden_design /home/DN03/COUNTER/OUTPUT/counter_netlist.v -revised_design /home/DN03/COUNTER/OUTPUT/counter.map.v > ./wlec_g1tog2_dofile
# Create SDF file
write_sdf -timescale ns -nonegchecks -recrem split -edges check_edge -setuphold split > /home/DN03/COUNTER/OUTPUT/delay.sdf
