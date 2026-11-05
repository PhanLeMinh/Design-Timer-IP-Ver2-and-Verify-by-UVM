package seq_pkg;
   import uvm_pkg::*;
   import timer_regmodel_pkg::*;
   import apb_pkg::*; 
   
   `include "uvm_macros.svh"
   `include "timer_cnt_seq.sv"
   `include "timer_cnt_rand_pre_seq.sv"
   `include "pwm_cnt_seq.sv"
   `include "pwm_cnt_rand_pre_seq.sv"
   `include "timer_halt_seq.sv"
   `include "apb_raw_sequence.sv"
endpackage
