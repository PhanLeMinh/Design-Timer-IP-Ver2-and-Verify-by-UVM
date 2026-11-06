class timer_tdr_pstrb_test extends apb_base_test;
   `uvm_component_utils(timer_tdr_pstrb_test)

   timer_reg_block regmodel;

   function new(string name = "timer_tdr_pstrb_test",uvm_component parent);
      super.new(name,parent);
   endfunction

   virtual function void build_phase(uvm_phase phase);
      super.build_phase(phase);
   endfunction

   virtual task run_phase(uvm_phase phase);
      uvm_status_e status;
      uvm_reg_data_t r_tdr0;
      uvm_reg_data_t r_tdr1;

      phase.raise_objection(this);
      regmodel = timer_env.reg_model;
      
      // TDR0
      write_reg_strobe(regmodel.TDR0, 32'hFFFF_FFFF, 4'hF);
      regmodel.TDR0.read(status,r_tdr0);
      if(r_tdr0 != 32'hFFFF_FFFF) `uvm_error(get_type_name(),"Data mismatch!")

      write_reg_strobe(regmodel.TDR0, 32'h5555_5555, 4'b0001);
      regmodel.TDR0.read(status,r_tdr0);
      if(r_tdr0 != 32'hFFFF_FF55) `uvm_error(get_type_name(),"Data mismatch!")
      
      write_reg_strobe(regmodel.TDR0, 32'h4444_4444, 4'b0010);
      regmodel.TDR0.read(status,r_tdr0);
      if(r_tdr0 != 32'hFFFF_4455) `uvm_error(get_type_name(),"Data mismatch!")

      write_reg_strobe(regmodel.TDR0, 32'h3333_3333, 4'b0100);
      regmodel.TDR0.read(status,r_tdr0);
      if(r_tdr0 != 32'hFF33_4455) `uvm_error(get_type_name(),"Data mismatch!")

      write_reg_strobe(regmodel.TDR0, 32'h2222_2222, 4'b1000);
      regmodel.TDR0.read(status,r_tdr0);
      if(r_tdr0 != 32'h2233_4455) `uvm_error(get_type_name(),"Data mismatch!")

      // TDR1
      write_reg_strobe(regmodel.TDR1, 32'hFFFF_FFFF, 4'hF);
      regmodel.TDR1.read(status,r_tdr1);
      if(r_tdr1 != 32'hFFFF_FFFF) `uvm_error(get_type_name(),"Data mismatch!")

      write_reg_strobe(regmodel.TDR1, 32'h5555_5555, 4'b0001);
      regmodel.TDR1.read(status,r_tdr1);
      if(r_tdr1 != 32'hFFFF_FF55) `uvm_error(get_type_name(),"Data mismatch!")

      write_reg_strobe(regmodel.TDR1, 32'h4444_4444, 4'b0010);
      regmodel.TDR1.read(status,r_tdr1);
      if(r_tdr1 != 32'hFFFF_4455) `uvm_error(get_type_name(),"Data mismatch!")

      write_reg_strobe(regmodel.TDR1, 32'h3333_3333, 4'b0100);
      regmodel.TDR1.read(status,r_tdr1);
      if(r_tdr1 != 32'hFF33_4455) `uvm_error(get_type_name(),"Data mismatch!")

      write_reg_strobe(regmodel.TDR1, 32'h2222_2222, 4'b1000);
      regmodel.TDR1.read(status,r_tdr1);
      if(r_tdr1 != 32'h2233_4455) `uvm_error(get_type_name(),"Data mismatch!")
      #10ns;

      phase.drop_objection(this);
   endtask
endclass
