class timer_disable_test extends apb_base_test;
    `uvm_component_utils(timer_disable_test)

    timer_reg_block regmodel;

    function new(string name = "timer_disbale_test",uvm_component parent);
       super.new(name,parent);
    endfunction

   virtual function void build_phase(uvm_phase phase);
      super.build_phase(phase);
   endfunction

   virtual task run_phase(uvm_phase phase);
      uvm_status_e status;
      uvm_reg_data_t rdata;
      phase.raise_objection(this);

      regmodel = timer_env.reg_model;
      regmodel.TCR.write(status,32'h0000_0001); //timer_en = 1
      #50ns;
      regmodel.TCR.write(status,32'h0000_0000);
      #100ns;
      regmodel.TCR.write(status,32'h0000_0001);
      #50ns;

      phase.drop_objection(this);
   endtask
endclass
