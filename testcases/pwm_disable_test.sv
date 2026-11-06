class pwm_disable_test extends apb_base_test;
    `uvm_component_utils(pwm_disable_test)

    timer_reg_block regmodel;

    function new(string name = "pwm_disbale_test",uvm_component parent);
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
      regmodel.TCMP0.write(status,32'd10);
      regmodel.TCMP1.write(status,32'd5);
      regmodel.TIER.write(status,32'h01);
      regmodel.TCR.write(status,32'h0000_0009); //pwm_en = 1, timer_en=1
      #50ns;
      regmodel.TCR.write(status,32'h0000_0008);
      regmodel.TISR.write(status,32'h02); // clear pwm_int_st
      regmodel.TISR.read(status,rdata);
      if(rdata[1] != 1'b0) `uvm_error(get_type_name(),"Flag interrupt NOT deleted!!")
      #100ns;
      regmodel.TCR.write(status,32'h0000_0009);
      
      fork
         forever begin
            @(posedge timer_vif.pwm_int);
            `uvm_info(get_type_name(),"PWM Interrupt asserted",UVM_LOW)
	    break;
         end
         begin
            #2000ns;
            `uvm_error(get_type_name(),"PWM Interrupt NOT assert")
         end
      join_any
      disable fork;

      #20ns;
      phase.drop_objection(this);
   endtask
endclass
