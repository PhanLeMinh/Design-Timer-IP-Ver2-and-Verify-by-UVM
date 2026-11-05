class timer_cnt_load_test extends apb_base_test;
   `uvm_component_utils(timer_cnt_load_test)

   uvm_status_e status;
   timer_reg_block regmodel;


   function new(string name = "timer_cnt_load_test",uvm_component parent);
      super.new(name,parent);
   endfunction

   virtual function void build_phase(uvm_phase phase);
      super.build_phase(phase);
   endfunction

   virtual task run_phase(uvm_phase phase);
      uvm_reg_data_t load_tdr0;
      uvm_reg_data_t load_tdr1;
      uvm_status_e status;

      bit [31:0] tdr0_val = $urandom_range(32'd1000,32'd100);
      bit [31:0] tdr1_val = $urandom_range(32'd10 ,32'd1);

      phase.raise_objection(this);
      regmodel = timer_env.reg_model;

      regmodel.TDR0.write(status,tdr0_val);
      regmodel.TDR1.write(status,tdr1_val);

      regmodel.TDR0.read(status,load_tdr0);
      regmodel.TDR1.read(status,load_tdr1);

      if(tdr0_val != load_tdr0 || tdr1_val != load_tdr1) begin
         `uvm_error(get_type_name(),"Load failed")
      end else begin
         `uvm_info(get_type_name(),"Load successful",UVM_LOW)
      end

      regmodel.TCR.write(status,32'h0000_0001);
      #50ns;
      regmodel.TDR0.read(status,load_tdr0);
      regmodel.TDR1.read(status,load_tdr1);
      if({tdr1_val,tdr0_val} <= {load_tdr1,load_tdr0}) begin
         `uvm_info(get_type_name(),"TEST PASSED: Counter incremented from loaded value",UVM_LOW)
      end
      else begin
         `uvm_error(get_type_name(),"TEST FAILED: Counter NOT incremented!!!")
      end
      #10ns;
      phase.drop_objection(this);
   endtask

endclass
