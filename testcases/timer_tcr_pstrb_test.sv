class timer_tcr_pstrb_test extends apb_base_test;
   `uvm_component_utils(timer_tcr_pstrb_test)

   timer_reg_block regmodel;

   function new(string name = "timer_tcr_pstrb_test",uvm_component parent);
      super.new(name,parent);
   endfunction

   // write có trả status để check pslverr
   task write_tcr_strobe(bit [31:0] data, bit [3:0] pstrb, output uvm_status_e status);
      apb_reg_extension ext = new();
      ext.pstrb = pstrb;
      regmodel.TCR.write(status, data, .extension(ext));
   endtask

   task check_tcr(bit [31:0] exp, string msg);
      uvm_status_e status;
      uvm_reg_data_t rdata;
      regmodel.TCR.read(status, rdata);
      if(rdata !== exp)
         `uvm_error(get_type_name(),$sformatf("%s: TCR exp=0x%08h, act=0x%08h",msg,exp,rdata))
      else
         `uvm_info(get_type_name(),$sformatf("TEST PASSED: %s, TCR=0x%08h",msg,rdata),UVM_LOW)
   endtask

   virtual task run_phase(uvm_phase phase);
      uvm_status_e status;

      phase.raise_objection(this);
      regmodel = timer_env.reg_model;   // sau reset: TCR = 0x0000_0100, timer_en = 0

      // 1. pstrb = 0000: không byte nào được ghi -> TCR giữ nguyên
      write_tcr_strobe(32'hFFFF_FFFF, 4'b0000, status);
      if(status != UVM_IS_OK) `uvm_error(get_type_name(),"pslverr with pstrb=0000")
      check_tcr(32'h0000_0100, "pstrb=0000");

      // 2. pstrb[0] = 0: byte0 (timer_en/div_en/div_mode/pwm_en) không đổi
      //    wdata[11:8] = 1 = div_val hiện tại nên không có lỗi
      write_tcr_strobe(32'h1234_010F, 4'b1110, status);
      if(status != UVM_IS_OK) `uvm_error(get_type_name(),"pslverr with pstrb=1110")
      check_tcr(32'h1234_0100, "pstrb=1110 (byte0 not written)");

      // 3. chỉ pstrb[0]: ghi div_en, div_mode, pwm_en (timer_en = 0 nên không lỗi)
      write_tcr_strobe(32'hFFFF_FF0E, 4'b0001, status);
      if(status != UVM_IS_OK) `uvm_error(get_type_name(),"pslverr with pstrb=0001")
      check_tcr(32'h1234_010E, "pstrb=0001 (byte0 only)");

      // 4. chỉ pstrb[1]: div_val = 5
      write_tcr_strobe(32'h0000_0500, 4'b0010, status);
      if(status != UVM_IS_OK) `uvm_error(get_type_name(),"pslverr with pstrb=0010")
      check_tcr(32'h1234_050E, "pstrb=0010 (div_val=5)");

      // 5. div_val illegal (9) nhưng pstrb[1] = 0 -> không lỗi, div_val giữ nguyên
      write_tcr_strobe(32'h1234_090E, 4'b1101, status);   // 0000 -> 1234
      if(status != UVM_IS_OK) `uvm_error(get_type_name(),"pslverr should NOT assert when pstrb[1]=0")
      check_tcr(32'h1234_050E, "pstrb=1101 (illegal div_val ignored)");
      
      // 6. byte2, byte3 -> prescaler
      write_tcr_strobe(32'h00AB_0000, 4'b0100, status);
      check_tcr(32'h12AB_050E, "pstrb=0100 (prescaler[7:0])");
      write_tcr_strobe(32'h5500_0000, 4'b1000, status);
      check_tcr(32'h55AB_050E, "pstrb=1000 (prescaler[15:8])");

      // 7. trả TCR về reset value
      write_tcr_strobe(32'h0000_0100, 4'hF, status);
      #20ns;

      phase.drop_objection(this);
   endtask
endclass
