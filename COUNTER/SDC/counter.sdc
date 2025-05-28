# Create Clock (2GHz)
create_clock -name clk -period 0.5 -waveform {0 0.25} [get_ports clk]

# Set input delay 
set_input_delay 0.3 -clock clk [get_ports en] 
set_input_delay 0.3 -clock clk [get_ports rst_n]

# Set output delay 
set_output_delay 0.3 -clock clk [get_ports q*]

# Reset
set_case_analysis 0 [get_ports rst_n]

set_dont_use [get_lib_cells *X12*]
set_dont_use [get_lib_cells *X16*]
set_dont_use [get_lib_cells *X20*]

# Margin for driver
#set_db opt_drv_margin 0.2

# Uncertainty 
set_clock_uncertainty 0.095 [get_clocks clk]

# Drive strength rules
set_max_transition 0.05 [get_clocks clk] 
set_max_transition 0.1 [get_ports en] 
set_max_transition 0.1 [get_ports rst_n] 

# Loading & fanout constraint
set_max_capacitance 8 [current_design] 
set_max_fanout 32 [current_design]

