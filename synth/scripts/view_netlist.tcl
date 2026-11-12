set DESIGN_NAME "timer_top"
set LIB_DIR "/home/dtvt_07/Downloads/gsclib045_all_v4.7/gsclib045/timing"
set TARGET_LIB "slow_vdd1v0_basicCells.lib"

set_db init_lib_search_path $LIB_DIR
set_db library $TARGET_LIB

read_netlist outputs/${DESIGN_NAME}_netlist.v
read_sdc outputs/${DESIGN_NAME}_synth.sdc
gui_show
puts "\n=== Post-synthesis netlist loaded into GUI successfully! ===\n"
