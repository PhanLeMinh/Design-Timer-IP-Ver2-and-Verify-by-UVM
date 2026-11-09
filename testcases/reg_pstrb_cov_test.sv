class reg_pstrb_cov_test extends apb_base_test;
   `uvm_component_utils(reg_pstrb_cov_test)

   timer_reg_block regmodel;

   function new(string name = "reg_pstrb_cov_test",uvm_component parent);
      super.new(name,parent);
   endfunction

   task chk(string msg, uvm_reg_data_t act, uvm_reg_data_t exp, uvm_reg_data_t mask = 32'hFFFF_FFFF);
      if((act & mask) !== (exp & mask))
         `uvm_error(get_type_name(),$sformatf("%s: exp=0x%08h act=0x%08h",msg,exp & mask,act & mask))
      else
         `uvm_info(get_type_name(),$sformatf("TEST PASSED: %s",msg),UVM_LOW)
   endtask

   virtual task run_phase(uvm_phase phase);
      uvm_status_e status;
      uvm_reg_data_t rdata;

      phase.raise_objection(this);
      regmodel = timer_env.reg_model;

      //------------------------------------------------------------
      // A. TCR khi timer_en = 1: lines 141, 142, 143 (pstrb_0 terms)
      //------------------------------------------------------------
      regmodel.TCR.write(status,32'h0000_0101);   // timer_en = 1, div_val = 1
      // pstrb = 0: wdata[11:8], [1], [3] đều khác hiện tại nhưng không byte nào được ghi -> không lỗi
      write_reg_strobe(regmodel.TCR,32'h0000_0F0A,4'b0000);
      regmodel.TCR.read(status,rdata);
      chk("TCR pstrb=0000 while timer_en=1",rdata,32'h0000_0101);
      // pstrb[0] = 0, pstrb[1] = 1, div_val giữ nguyên -> không lỗi
      write_reg_strobe(regmodel.TCR,32'h0000_010A,4'b0010);
      regmodel.TCR.read(status,rdata);
      chk("TCR pstrb=0010 while timer_en=1",rdata,32'h0000_0101);
      regmodel.TCR.write(status,32'h0000_0100);   // tắt timer
      #20ns;

      //------------------------------------------------------------
      // B. Ghi TDR0 khi pwm_en = 1: line 168 (pwm_en_1)
      //------------------------------------------------------------
      regmodel.TCR.write(status,32'h0000_0108);   // pwm_en = 1, timer_en = 0 -> không lỗi
      regmodel.TDR0.write(status,32'h0000_1234);  // bị bỏ qua
      regmodel.TDR0.read(status,rdata);
      if(rdata === 32'h0000_1234)
         `uvm_error(get_type_name(),"TDR0 write should be ignored when pwm_en=1")
      else
         `uvm_info(get_type_name(),"TEST PASSED: TDR0 write ignored in PWM mode",UVM_LOW)
      regmodel.TCR.write(status,32'h0000_0100);   // pwm_en = 0
      #20ns;

      //------------------------------------------------------------
      // C. TIER pstrb[0] = 0: line 215
      //------------------------------------------------------------
      write_reg_strobe(regmodel.TIER,32'h1,4'b0000);
      regmodel.TIER.read(status,rdata);
      chk("TIER pstrb=0 (int_en 0->1 ignored)",rdata,32'h0);
      regmodel.TIER.write(status,32'h1);
      write_reg_strobe(regmodel.TIER,32'h0,4'b0000);
      regmodel.TIER.read(status,rdata);
      chk("TIER pstrb=0 (int_en 1->0 ignored)",rdata,32'h1);

      //------------------------------------------------------------
      // D. THCSR pstrb[0] = 0: line 277
      //------------------------------------------------------------
      write_reg_strobe(regmodel.THCSR,32'h1,4'b0000);
      regmodel.THCSR.read(status,rdata);
      chk("THCSR pstrb=0 (halt_req 0->1 ignored)",rdata,32'h0,32'h1);
      regmodel.THCSR.write(status,32'h1);
      write_reg_strobe(regmodel.THCSR,32'h0,4'b0000);
      regmodel.THCSR.read(status,rdata);
      chk("THCSR pstrb=0 (halt_req 1->0 ignored)",rdata,32'h1,32'h1);
      regmodel.THCSR.write(status,32'h0);

      //------------------------------------------------------------
      // E. TISR int_st (timer mode), pstrb[0] = 0: line 231, 232
      //------------------------------------------------------------
      regmodel.TDR0.write(status,32'h0);
      regmodel.TDR1.write(status,32'h0);
      regmodel.TCMP0.write(status,32'd5);
      regmodel.TCMP1.write(status,32'd0);
      regmodel.TCR.write(status,32'h0000_0101);
      #100ns;
      regmodel.TISR.read(status,rdata);
      chk("int_st set",rdata,32'h1,32'h1);
      write_reg_strobe(regmodel.TISR,32'h3,4'b0000);   // không được clear
      regmodel.TISR.read(status,rdata);
      chk("TISR pstrb=0 does NOT clear int_st",rdata,32'h1,32'h1);
      regmodel.TISR.write(status,32'h2);               // wdata[0] = 0 -> không clear int_st
      regmodel.TISR.read(status,rdata);
      chk("TISR write 0x2 does not clear int_st",rdata,32'h1,32'h1);
      regmodel.TISR.write(status,32'h1);               // clear thật
      regmodel.TISR.read(status,rdata);
      chk("TISR write 1 clears int_st",rdata,32'h0,32'h1);
      regmodel.TCR.write(status,32'h0000_0100);        // tắt timer
      #20ns;

      //------------------------------------------------------------
      // F. PWM: mask pwm_int (line 271) + TISR pstrb[0]=0 (line 232)
      //------------------------------------------------------------
      regmodel.TIER.write(status,32'h0);               // int_en = 0
      regmodel.TCMP0.write(status,32'd5);
      regmodel.TCMP1.write(status,32'd2);
      regmodel.TCR.write(status,32'h0000_0108);        // pwm_en = 1, timer_en = 0
      regmodel.TCR.write(status,32'h0000_0109);        // timer_en = 1
      #100ns;
      regmodel.TCR.write(status,32'h0000_0108);        // dừng counter, giữ pwm_int_st
      regmodel.TISR.read(status,rdata);
      chk("pwm_int_st set",rdata,32'h2,32'h2);
      if(timer_vif.pwm_int !== 1'b0)
         `uvm_error(get_type_name(),"pwm_int asserted while int_en = 0")
      else
         `uvm_info(get_type_name(),"TEST PASSED: pwm_int masked by int_en=0",UVM_LOW)

      regmodel.TIER.write(status,32'h1);               // unmask
      #10ns;
      if(timer_vif.pwm_int !== 1'b1)
         `uvm_error(get_type_name(),"pwm_int should assert when int_en = 1")
      write_reg_strobe(regmodel.TISR,32'h3,4'b0000);   // không được clear
      regmodel.TISR.read(status,rdata);
      chk("TISR pstrb=0 does NOT clear pwm_int_st",rdata,32'h2,32'h2);
      regmodel.TISR.write(status,32'h2);               // clear thật
      regmodel.TISR.read(status,rdata);
      chk("TISR write 2 clears pwm_int_st",rdata,32'h0,32'h2);

      regmodel.TCR.write(status,32'h0000_0100);        // về trạng thái reset
      #20ns;

      phase.drop_objection(this);
   endtask
endclass
