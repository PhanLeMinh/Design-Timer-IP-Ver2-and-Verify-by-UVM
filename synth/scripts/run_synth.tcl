set DESIGN_NAME "timer_top"
set LIB_DIR "/home/dtvt_07/Downloads/gsclib045_all_v4.7/gsclib045/timing"
set TARGET_LIB "slow_vdd1v0_basicCells.lib"

# 1. Environment & Library Setup
set_db init_lib_search_path $LIB_DIR
set_db library $TARGET_LIB
set_db information_level 7

# 2. Read RTL
read_hdl -v2001 {
    ../rtl/apb_slave.v
    ../rtl/counter_control.v
    ../rtl/counter.v
    ../rtl/pwm_counter.v
    ../rtl/register.v
    ../rtl/timer_top.v
}

# 3. Elaborate Design
elaborate $DESIGN_NAME
check_design -unresolved

# 4. Constraints
read_sdc scripts/timer_top.sdc
check_timing_intent

# 5. Generic Synthesis
syn_gen

# 6. Technology Mapping
syn_map

# 7. Optimization
syn_opt

# 8. Reports
report_timing > reports/${DESIGN_NAME}_timing.rpt
report_area > reports/${DESIGN_NAME}_area.rpt
report_gates > reports/${DESIGN_NAME}_gates.rpt
report_power > reports/${DESIGN_NAME}_power.rpt
report_qor > reports/${DESIGN_NAME}_qor.rpt

# 9. Netlist & SDC Export
write_hdl > outputs/${DESIGN_NAME}_netlist.v
write_sdc > outputs/${DESIGN_NAME}_synth.sdc

puts "\n=============================================="
puts "  SYNTHESIS COMPLETED SUCCESSFULLY!"
puts "==============================================\n"
