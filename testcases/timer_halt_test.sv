class timer_halt_test extends apb_base_test;
   `uvm_component_utils(timer_halt_test)

   timer_halt_seq halt_seq;

   function new(string name = "timer_halt_test",uvm_component parent);
      super.new(name,parent);
   endfunction

   virtual function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      halt_seq = timer_halt_seq::type_id::create("halt_seq");
      if(!halt_seq.randomize() with {div_val==4'd0;})
         `uvm_fatal(get_type_name(),"Failed randomize halt_seq")
   endfunction

   virtual task run_phase(uvm_phase phase);
      phase.raise_objection(this);
      
      halt_seq.regmodel = timer_env.reg_model;
      halt_seq.timer_vif = timer_vif;
      halt_seq.start(timer_env.apb_agt.apb_seq);

      phase.drop_objection(this);
   endtask
endclass
