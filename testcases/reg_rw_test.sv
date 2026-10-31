class reg_rw_test extends apb_base_test;
   `uvm_component_utils(reg_rw_test)

   function new(string name = "reg_rw_test",uvm_component parent);
      super.new(name,parent);
   endfunction

   virtual task run_phase(uvm_phase phase);
      uvm_reg_bit_bash_seq bit_bash_seq;
      phase.raise_objection(this);

      uvm_resource_db#(bit)::set({"REG::", timer_env.reg_model.TCR.get_full_name()},"NO_REG_BIT_BASH_TEST", 1, this);

      uvm_resource_db#(bit)::set({"REG::", timer_env.reg_model.TISR.get_full_name()},"NO_REG_BIT_BASH_TEST", 1, this);

      bit_bash_seq = uvm_reg_bit_bash_seq::type_id::create("bit_bash_seq");
      bit_bash_seq.model = timer_env.reg_model;
      
      bit_bash_seq.start(timer_env.apb_agt.apb_seq);

      #100ns;
      phase.drop_objection(this);
   endtask
endclass
