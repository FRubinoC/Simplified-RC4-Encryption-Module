create_clock -name clock -period 10 [get_ports clock]

set_false_path -from [get_ports rst_n] -to [get_clocks clock]

set_input_delay  -min 1 -clock [get_clocks clock] [all_inputs]
set_input_delay  -max 2 -clock [get_clocks clock] [all_inputs]
set_output_delay -min 1 -clock [get_clocks clock] [all_outputs]
set_output_delay -max 2 -clock [get_clocks clock] [all_outputs]
