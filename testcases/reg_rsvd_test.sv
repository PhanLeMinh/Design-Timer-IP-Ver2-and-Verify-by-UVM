class reg_rsvd_test extends apb_base_test;
   `uvm_component_utils(reg_rsvd_test)

   function new(string name = "",uvm_component parent);
      super.new(name,parent);
   endfunction

   virtual task run_phase(uvm_phase phase);
      uvm_status_e status;
      uvm_reg_data_t rdata;

      phase.raise_objection(this);

      wait(apb_vif.prst_n == 1);

      // TCR register
      timer_env.reg_model.TCR.write(status,32'hFFFF_F8FF);
      timer_env.reg_model.TCR.read(status,rdata);
      if(rdata === 32'hFFFF_080F) begin
         `uvm_info(get_type_name(),$sformatf("TEST PASSED: rdata %0h",rdata),UVM_LOW)
      end
      else begin
         `uvm_error(get_type_name(),$sformatf("TEST FAILED: rdata %0h",rdata))
      end

      // TIER register
      timer_env.reg_model.TIER.write(status,32'hFFFF_FFFF);
      timer_env.reg_model.TIER.read(status,rdata);
      if(rdata === 32'h0000_0001) begin
         `uvm_info(get_type_name(),$sformatf("TEST PASSED: rdata %0h",rdata),UVM_LOW)
      end
      else begin
         `uvm_error(get_type_name(),$sformatf("TEST FAILED: rdata %0h",rdata))
      end

      // TISR register
      timer_env.reg_model.TISR.write(status,32'hFFFF_FFFF);
      timer_env.reg_model.TISR.read(status,rdata);
      if(rdata === 32'h0000_0000) begin
         `uvm_info(get_type_name(),$sformatf("TEST PASSED: rdata %0h",rdata),UVM_LOW)
      end
      else begin
         `uvm_error(get_type_name(),$sformatf("TEST FAILED: rdata %0h",rdata))
      end

      // THCSR register
      timer_env.reg_model.THCSR.write(status,32'hFFFF_FFFF);
      timer_env.reg_model.THCSR.read(status,rdata);
      if(rdata === 32'h0000_0001) begin
         `uvm_info(get_type_name(),$sformatf("TEST PASSED: rdata %0h",rdata),UVM_LOW)
      end
      else begin
         `uvm_error(get_type_name(),$sformatf("TEST FAILED: rdata %0h",rdata))
      end


      #100ns;
      phase.drop_objection(this);
   endtask
endclass
