package test_pkg;
   import uvm_pkg::*;
   `include "uvm_macros.svh"
   import env_pkg::*;
   import apb_pkg::*;
   import seq_pkg::*;
   import timer_regmodel_pkg::*;

   `include "apb_base_test.sv"
   `include "reg_def_test.sv"
   `include "reg_rw_test.sv"
   `include "reg_rs_fly_test.sv"
   `include "reg_rsvd_test.sv"

   `include "timer_cnt_div0_test.sv"
   `include "timer_cnt_div2_test.sv"
   `include "timer_cnt_div4_test.sv"
   `include "timer_cnt_div8_test.sv"
   `include "timer_cnt_div16_test.sv"
   `include "timer_cnt_div32_test.sv"
   `include "timer_cnt_div64_test.sv"
   `include "timer_cnt_div128_test.sv"
   `include "timer_cnt_div256_test.sv"

   `include "timer_cnt_pre1_test.sv"
   `include "timer_cnt_pre2_test.sv"
   `include "timer_cnt_pre_ffff_test.sv"
   `include "timer_cnt_rand_pre_test.sv"
   
   `include "timer_disable_test.sv"

   `include "pwm_cnt_div0_test.sv"
   `include "pwm_cnt_div2_test.sv"
   `include "pwm_cnt_div4_test.sv"
   `include "pwm_cnt_div8_test.sv"
   `include "pwm_cnt_div16_test.sv"
   `include "pwm_cnt_div32_test.sv"
   `include "pwm_cnt_div64_test.sv"
   `include "pwm_cnt_div128_test.sv"
   `include "pwm_cnt_div256_test.sv"

   `include "pwm_cnt_pre0_test.sv"
   `include "pwm_cnt_pre1_test.sv"
   `include "pwm_cnt_pre_ffff_test.sv"
   `include "pwm_cnt_rand_pre_test.sv"

   `include "pwm_disable_test.sv"

   `include "timer_halt_test.sv"
   `include "pwm_halt_test.sv"

   `include "timer_illegal_div_val_test.sv"
   `include "on_the_fly_write_test.sv"
   `include "timer_cnt_load_test.sv"
   `include "timer_tdr_pstrb_test.sv"
   `include "timer_tcmp_pstrb_test.sv"
   `include "unmapped_addr_test.sv"
   `include "timer_int_mask_test.sv"
   `include "timer_tcmp_max_test.sv"
   `include "timer_tcr_pstrb_test.sv"
   `include "reg_pstrb_cov_test.sv"

endpackage
