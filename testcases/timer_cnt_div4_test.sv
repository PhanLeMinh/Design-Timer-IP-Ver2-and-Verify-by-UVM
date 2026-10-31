class timer_cnt_div4_test extends apb_base_test;
   `uvm_component_utils(timer_cnt_div4_test)

   timer_cnt_seq timer_seq;

   function new(string name = "timer_cnt_div4_test",uvm_component parent);
      super.new(name,parent);
   endfunction

   virtual function void build_phase(uvm_phase phase);
      super.build_phase(phase); 
      timer_seq = timer_cnt_seq::type_id::create("timer_seq");
      if(!timer_seq.randomize() with{div_val==4'd2;}) // devide 4
         `uvm_fatal(get_type_name(),"Failed to randomize timer_seq")
   endfunction

   virtual task run_phase(uvm_phase phase);
       phase.raise_objection(this);

       timer_seq.regmodel = timer_env.reg_model;
       timer_seq.start(null);

       phase.drop_objection(this);
   endtask
endclass
