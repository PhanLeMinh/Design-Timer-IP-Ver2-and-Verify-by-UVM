class tcmp_max_test extends apb_base_test;
   `uvm_component_utils(tcmp_max_test)

   timer_reg_block regmodel;

   function new(string name = "tcmp_max_test",uvm_component parent);
      super.new(name,parent);
   endfunction

   virtual function void build_phase(uvm_phase phase);
      super.build_phase(phase);
   endfunction

   virtual task run_phase(uvm_phase phase);
      uvm_status_e status;
      phase.raise_objection(this);

      regmodel = timer_env.reg_model;
      regmodel.TCMP0.write(status,32'hFFFF_FFFF);
      regmodel.TCMP1.write(status,32'hFFFF_FFFF);
      regmodel.TDR0.write(status,32'hFFFF_FFF0);
      regmodel.TDR1.write(status,32'hFFFF_FFFF);
      regmodel.TIER.write(status,32'h0000_0001);
      regmodel.TCR.write(status,32'h0000_0001); //timer_en=1
      fork 
         begin
	    @(posedge timer_vif.tim_int);
	    `uvm_info(get_type_name(), "TEST PASSED: tim_int asserted at MAX 64-bit compare!", UVM_LOW)
	 end
	 begin
	    #500ns;
	    `uvm_error(get_type_name(), "TEST FAILED: Timeout waiting for tim_int!")
	 end
      join_any
      disable fork;
      #20ns;

      phase.drop_objection(this);
   endtask
endclass
