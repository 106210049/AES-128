# ####################################################################

#  Created by Genus(TM) Synthesis Solution 22.12-s082_1 on Tue May 06 15:57:31 +07 2025

# ####################################################################

set sdc_version 2.0

set_units -capacitance 1000fF
set_units -time 1000ps

# Set the current design
current_design counter

set_case_analysis 0 [get_ports rst_n]
create_clock -name "clk" -period 0.5 -waveform {0.0 0.25} [get_ports clk]
group_path -name in2reg -from [list \
  [get_ports clk]  \
  [get_ports rst_n]  \
  [get_ports en] ] -to [list \
  [get_cells RC_CG_HIER_INST0/RC_CGIC_INST]  \
  [get_cells q_reg_6]  \
  [get_cells q_reg_5]  \
  [get_cells q_reg_3]  \
  [get_cells q_reg_7]  \
  [get_cells q_reg_4]  \
  [get_cells q_reg_2]  \
  [get_cells q_reg_1]  \
  [get_cells q_reg_0] ]
group_path -name reg2reg -from [list \
  [get_cells q_reg_6]  \
  [get_cells q_reg_5]  \
  [get_cells q_reg_3]  \
  [get_cells q_reg_7]  \
  [get_cells q_reg_4]  \
  [get_cells q_reg_2]  \
  [get_cells q_reg_1]  \
  [get_cells q_reg_0] ] -to [list \
  [get_cells RC_CG_HIER_INST0/RC_CGIC_INST]  \
  [get_cells q_reg_6]  \
  [get_cells q_reg_5]  \
  [get_cells q_reg_3]  \
  [get_cells q_reg_7]  \
  [get_cells q_reg_4]  \
  [get_cells q_reg_2]  \
  [get_cells q_reg_1]  \
  [get_cells q_reg_0] ]
group_path -name reg2out -from [list \
  [get_cells q_reg_6]  \
  [get_cells q_reg_5]  \
  [get_cells q_reg_3]  \
  [get_cells q_reg_7]  \
  [get_cells q_reg_4]  \
  [get_cells q_reg_2]  \
  [get_cells q_reg_1]  \
  [get_cells q_reg_0] ] -to [list \
  [get_ports {q[7]}]  \
  [get_ports {q[6]}]  \
  [get_ports {q[5]}]  \
  [get_ports {q[4]}]  \
  [get_ports {q[3]}]  \
  [get_ports {q[2]}]  \
  [get_ports {q[1]}]  \
  [get_ports {q[0]}] ]
group_path -name in2out -from [list \
  [get_ports clk]  \
  [get_ports rst_n]  \
  [get_ports en] ] -to [list \
  [get_ports {q[7]}]  \
  [get_ports {q[6]}]  \
  [get_ports {q[5]}]  \
  [get_ports {q[4]}]  \
  [get_ports {q[3]}]  \
  [get_ports {q[2]}]  \
  [get_ports {q[1]}]  \
  [get_ports {q[0]}] ]
group_path -name cg_enable_group_clk -through [list \
  [get_pins RC_CG_HIER_INST0/enable]  \
  [get_pins RC_CG_HIER_INST0/RC_CGIC_INST/E]  \
  [get_pins RC_CG_HIER_INST0/enable]  \
  [get_pins RC_CG_HIER_INST0/RC_CGIC_INST/E]  \
  [get_pins RC_CG_HIER_INST0/enable]  \
  [get_pins RC_CG_HIER_INST0/RC_CGIC_INST/E] ]
set_clock_gating_check -setup 0.0 
set_input_delay -clock [get_clocks clk] -add_delay 0.3 [get_ports en]
set_input_delay -clock [get_clocks clk] -add_delay 0.3 [get_ports rst_n]
set_output_delay -clock [get_clocks clk] -add_delay 0.3 [get_ports {q[7]}]
set_output_delay -clock [get_clocks clk] -add_delay 0.3 [get_ports {q[6]}]
set_output_delay -clock [get_clocks clk] -add_delay 0.3 [get_ports {q[5]}]
set_output_delay -clock [get_clocks clk] -add_delay 0.3 [get_ports {q[4]}]
set_output_delay -clock [get_clocks clk] -add_delay 0.3 [get_ports {q[3]}]
set_output_delay -clock [get_clocks clk] -add_delay 0.3 [get_ports {q[2]}]
set_output_delay -clock [get_clocks clk] -add_delay 0.3 [get_ports {q[1]}]
set_output_delay -clock [get_clocks clk] -add_delay 0.3 [get_ports {q[0]}]
set_max_fanout 32.000 [current_design]
set_max_transition 0.1 [get_ports rst_n]
set_max_transition 0.1 [get_ports en]
set_max_transition 0.05 [get_clocks clk]
set_max_capacitance 8.0 [current_design]
set_wire_load_mode "segmented"
set_dont_use true [get_lib_cells MEM2_128X16/MEM2_128X16]
set_dont_use true [get_lib_cells fast_vdd1v2/BUFX12]
set_dont_use true [get_lib_cells fast_vdd1v2/BUFX16]
set_dont_use true [get_lib_cells fast_vdd1v2/BUFX20]
set_dont_use true [get_lib_cells fast_vdd1v2/CLKAND2X12]
set_dont_use true [get_lib_cells fast_vdd1v2/CLKBUFX12]
set_dont_use true [get_lib_cells fast_vdd1v2/CLKBUFX16]
set_dont_use true [get_lib_cells fast_vdd1v2/CLKBUFX20]
set_dont_use true [get_lib_cells fast_vdd1v2/CLKINVX12]
set_dont_use true [get_lib_cells fast_vdd1v2/CLKINVX16]
set_dont_use true [get_lib_cells fast_vdd1v2/CLKINVX20]
set_dont_use true [get_lib_cells fast_vdd1v2/CLKMX2X12]
set_dont_use true [get_lib_cells fast_vdd1v2/INVX12]
set_dont_use true [get_lib_cells fast_vdd1v2/INVX16]
set_dont_use true [get_lib_cells fast_vdd1v2/INVX20]
set_dont_use true [get_lib_cells fast_vdd1v2/TBUFX12]
set_dont_use true [get_lib_cells fast_vdd1v2/TBUFX16]
set_dont_use true [get_lib_cells fast_vdd1v2/TBUFX20]
set_dont_use true [get_lib_cells fast_vdd1v2/TLATNCAX12]
set_dont_use true [get_lib_cells fast_vdd1v2/TLATNCAX16]
set_dont_use true [get_lib_cells fast_vdd1v2/TLATNCAX20]
set_dont_use true [get_lib_cells fast_vdd1v2/TLATNTSCAX12]
set_dont_use true [get_lib_cells fast_vdd1v2/TLATNTSCAX16]
set_dont_use true [get_lib_cells fast_vdd1v2/TLATNTSCAX20]
set_clock_uncertainty -setup 0.095 [get_clocks clk]
set_clock_uncertainty -hold 0.095 [get_clocks clk]
