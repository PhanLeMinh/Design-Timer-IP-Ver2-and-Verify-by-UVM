# SDC Constraints for Timer IP
# Clock: 250 MHz (period = 4.0 ns)
create_clock -name sys_clk -period 4.0 [get_ports sys_clk]

# Clock Uncertainty (Jitter / Margin)
set_clock_uncertainty 0.2 [get_clocks sys_clk]

# Clock Transition
set_clock_transition 0.1 [get_clocks sys_clk]

# Input Delay (assuming 20% of clock period)
set_input_delay -clock sys_clk -max 0.8 [remove_from_collection [all_inputs] [get_ports {sys_clk sys_rst_n}]]
set_input_delay -clock sys_clk -min 0.25 [remove_from_collection [all_inputs] [get_ports {sys_clk sys_rst_n}]]

# Output Delay (assuming 20% of clock period)
set_output_delay -clock sys_clk -max 0.8 [all_outputs]
set_output_delay -clock sys_clk -min 0.25 [all_outputs]

# External Load
set_load 0.05 [all_outputs]
