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
      regmodel.TCMP0.write(status,32'd100);
      regmodel.TCMP1.write(status,32'h0);
      regmodel.TIER.write(status,32'h01);
      regmodel.TCR.write(status,32'h0000_0001); //timer_en = 1
      #50ns;
      regmodel.TCR.write(status,32'h0000_0000);
      #50ns;
      regmodel.TCR.write(status,32'h0000_0001);
      fork
         forever begin
	    @(posedge timer_vif.tim_int);
	    `uvm_info(get_type_name(),"Interrupt asserted",UVM_LOW)
	    break;
	 end
	 begin
	    #2000ns;
	    `uvm_fatal(get_type_name(),"Interrupt NOT assert")
	 end
      join_any
      disable fork;

      #20ns;

      phase.drop_objection(this);
   endtask
endclass
