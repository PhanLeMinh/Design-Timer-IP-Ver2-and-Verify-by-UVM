class timer_halt_seq  extends uvm_sequence;
   `uvm_object_utils(timer_halt_seq)

   timer_reg_block regmodel;
   virtual timer_if timer_vif;

   rand bit halt_req;
   rand bit div_en;
   rand bit div_mode;
   rand bit pwm_en;
   rand bit [3:0] div_val;
   rand bit [15:0] prescaler;
   rand bit [31:0] tcmp0_val;
   rand bit [31:0] tcmp1_val;
   
   constraint halt_c{
      soft halt_req == 1;
      soft div_en   == 1;
      soft div_mode == 0;
      soft pwm_en   == 0;
      soft prescaler == 0;
      soft tcmp1_val == 32'h0;
   }

   constraint tcmp0_val_c{
      tcmp0_val inside {[32'd10:32'd50]};
   }

   local string msg = "TIMER_HALT_SEQ";

   function new(string name = "timer_halt_seq");
      super.new(name);
   endfunction

   virtual task body();
      uvm_status_e status;
      uvm_reg_data_t rdata;
      bit [31:0] tcr_val;

      if(regmodel == null) begin
         `uvm_fatal(msg,"Need assign regmodel")
      end
      
      #50ns;
      timer_vif.dbg_mode = 1'b1;
      regmodel.TCMP0.write(status,tcmp0_val);
      regmodel.TCMP1.write(status,tcmp1_val);
      tcr_val = {prescaler,4'b0,div_val,4'b0,div_mode,pwm_en,div_en,1'b1};
      regmodel.TCR.write(status,tcr_val);
      #100ns;
      regmodel.THCSR.write(status,{31'h0,halt_req});
      regmodel.THCSR.read(status,rdata);
      if(rdata[1] == 1'b1) begin 
        `uvm_info(msg,"TEST PASSED: Halt ack is asserted",UVM_LOW)
      end
      else begin
         `uvm_error(msg,"TEST FAILED");
      end
      #50ns;
      timer_vif.dbg_mode = 1'b0;
      regmodel.THCSR.read(status,rdata);
      if(rdata[1] == 1'b0) begin
        `uvm_info(msg,"TEST PASSED: Halt ack not effect",UVM_LOW)
      end
      else begin
         `uvm_error(msg,"TEST FAILED: Halt ack change not 1 -> 0");
      end
      regmodel.THCSR.write(status,32'h0);
      regmodel.TCR.write(status,tcr_val);
      #20ns;
   endtask
endclass
