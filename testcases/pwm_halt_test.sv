class pwm_halt_test extends apb_base_test;
   `uvm_component_utils(pwm_halt_test)

   timer_reg_block regmodel;

   function new(string name = "pwm_halt_test",uvm_component parent);
      super.new(name,parent);
   endfunction

   virtual function void build_phase(uvm_phase phase);
      super.build_phase(phase);
   endfunction

   virtual task run_phase(uvm_phase phase);
      uvm_status_e status;
      uvm_reg_data_t rdata1;
      uvm_reg_data_t rdata2;

      phase.raise_objection(this);

      regmodel = timer_env.reg_model;
      regmodel.TCR.write(status,32'h0000_0005); // timer_en = 1, pwm_en = 1;
      #50ns;
      regmodel.TDR0.read(status,rdata1);
      regmodel.THCSR.write(status,32'h0000_0001); // halt_req = 1;
      #20ns;
      regmodel.TDR0.read(status,rdata2);
      if(rdata1 == rdata2) begin
         `uvm_error(get_type_name(),"Halt request no effect with PWM mode")
      end
      else begin
         `uvm_info(get_type_name(),"TEST PASSED",UVM_LOW)
      end
      #20ns;

      phase.drop_objection(this);
   endtask
endclass
