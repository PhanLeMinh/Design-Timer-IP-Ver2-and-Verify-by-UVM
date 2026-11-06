class on_the_fly_write_test extends apb_base_test;
   `uvm_component_utils(on_the_fly_write_test)

   timer_reg_block regmodel;
   uvm_status_e status;
   uvm_reg_data_t rdata;

   function new(string name = "on_the_fly_write_test",uvm_component parent);
      super.new(name,parent);
   endfunction

   function void build_phase(uvm_phase phase);
      super.build_phase(phase);
   endfunction

   virtual task run_phase(uvm_phase phase);
      phase.raise_objection(this);

      regmodel = timer_env.reg_model;
      regmodel.TCR.write(status,32'h0000_0103); // set timer_en = 1,div_en = 1, div_val = 1;
      if(status != UVM_IS_OK) 
         `uvm_error(get_type_name(),"Initial write failed")
      #20ns;
      regmodel.TCR.write(status,32'h0000_0003); // div_val 1 -> 0
      if(status != UVM_NOT_OK)
         `uvm_error(get_type_name(),"On the fly div_val change NOT trigger pslverr")
      #20ns;
      regmodel.TCR.write(status,32'h0000_0101); // div_en 1 -> 0
      if(status != UVM_NOT_OK)
         `uvm_error(get_type_name(),"On the fly div_en change NOT trigger pslverr")
      #20ns;
      regmodel.TCR.write(status,32'h0000_0109); // pwm_en 0 -> 1
      if(status != UVM_NOT_OK)
         `uvm_error(get_type_name(),"On the fly pwm_en change NOT trigger pslverr")
      #20ns;
      regmodel.TCR.read(status,rdata);
      if(rdata[11:8] !=4'd1 || rdata[1] != 1'b1 || rdata[3] != 1'b0) 
         `uvm_error(get_type_name(),$sformatf("Registers were illegally modified on-the-fly! TCR = 0x%08h", rdata))
      #20ns;
      phase.drop_objection(this);
   endtask
endclass
