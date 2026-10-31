class pwm_cnt_pre0_test extends apb_base_test;
   `uvm_component_utils(pwm_cnt_pre0_test)

   pwm_cnt_rand_pre_seq pwm_rand_pre_seq;

   function new(string name = "pwm_cnt_pre0_test",uvm_component parent);
      super.new(name,parent);
   endfunction

   virtual function void build_phase(uvm_phase phase);
      super.build_phase(phase); 
      pwm_rand_pre_seq = pwm_cnt_rand_pre_seq::type_id::create("pwm_rand_pre_seq");
      if(!pwm_rand_pre_seq.randomize() with{prescaler==16'd0;})
         `uvm_fatal(get_type_name(),"Failed to randomize pwm_rand_pre_seq")
   endfunction

   virtual task run_phase(uvm_phase phase);
       phase.raise_objection(this);

       pwm_rand_pre_seq.regmodel = timer_env.reg_model;
       pwm_rand_pre_seq.start(null);

       phase.drop_objection(this);
   endtask
endclass
