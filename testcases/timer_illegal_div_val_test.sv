class timer_illegal_div_val_test extends apb_base_test;
   `uvm_component_utils(timer_illegal_div_val_test)

   timer_reg_block regmodel;
   uvm_status_e status;
   uvm_reg_data_t rdata;

   function new(string name = "timer_illegal_div_val_test",uvm_component parent);
      super.new(name,parent);
   endfunction

   virtual function void build_phase(uvm_phase phase);
      super.build_phase(phase);
   endfunction

   virtual task run_phase(uvm_phase phase);
      phase.raise_objection(this);

      regmodel = timer_env.reg_model;

      regmodel.TCR.write(status,32'h0000_0900);
      if(status ==  UVM_NOT_OK) begin
         `uvm_info(get_type_name(),"Pslverr is asserted",UVM_LOW)
      end
      else begin
         `uvm_error(get_type_name(),"Pslverr is NOT asserted")
      end

      regmodel.TCR.read(status,rdata);
      if(rdata[11:8] !=  4'd1) begin
         `uvm_error(get_type_name(),$sformatf("div_val should NOT be modifiled, actual = %0d ",rdata[11:8]))
      end
      #10ns;

      phase.drop_objection(this);
   endtask

endclass
