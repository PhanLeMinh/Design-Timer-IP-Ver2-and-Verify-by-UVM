class reg_rs_fly_test extends apb_base_test;
   `uvm_component_utils(reg_rs_fly_test)

   function new(string name = "reg_rs_fly_test",uvm_component parent);
      super.new(name,parent);
   endfunction

   virtual task run_phase(uvm_phase phase);
       uvm_status_e status;
       uvm_reg_data_t rdata;

       phase.raise_objection(this);
       timer_env.reg_model.TCMP0.write(status,32'd1000);
       timer_env.reg_model.TCR.write(status,32'h0000_0003); // timer_en = 1
       `uvm_info(get_type_name(),"******Start Couner******",UVM_LOW)
       #500ns;
       timer_env.reg_model.TDR0.read(status,rdata);
       `uvm_info(get_type_name(),$sformatf("Counter value %0d",rdata),UVM_LOW)

       apb_vif.prst_n = 1'b0; // reset = 0

       repeat(5) @(posedge apb_vif.pclk);

       apb_vif.prst_n = 1'b1; // reset = 1
       repeat(2) @(posedge apb_vif.pclk);

       timer_env.reg_model.reset(); // Syschronous RAL

       timer_env.reg_model.TCR.mirror(status,UVM_CHECK); // Update mirror RAL
       timer_env.reg_model.TCMP0.mirror(status,UVM_CHECK);
       timer_env.reg_model.TDR0.mirror(status,UVM_CHECK);

       timer_env.reg_model.TCMP0.write(status,32'd50);
       timer_env.reg_model.TCR.write(status,32'h0000_0003); // Timer ON

       #200ns;
       timer_env.reg_model.TDR0.read(status,rdata);

       if(rdata > 0) begin
          `uvm_info(get_type_name(),"TEST PASSED",UVM_LOW)
       end
       else begin
          `uvm_fatal(get_type_name(),"TEST FAILED")
       end

       phase.drop_objection(this);
   endtask
endclass
