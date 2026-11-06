class unmapped_addr_test extends apb_base_test;
   `uvm_component_utils(unmapped_addr_test)

   timer_unmapped_addr_seq addr_seq;

   function new(string name = "unmapped_addr_test",uvm_component parent);
      super.new(name,parent);
   endfunction

   virtual function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      addr_seq = timer_unmapped_addr_seq::type_id::create("addr_seq");
   endfunction

   virtual task run_phase(uvm_phase phase);
      phase.raise_objection(this);
      
      addr_seq.start(timer_env.apb_agt.apb_seq);

      phase.drop_objection(this);
   endtask
endclass
