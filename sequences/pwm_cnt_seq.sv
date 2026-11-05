class pwm_cnt_seq extends uvm_sequence;
   `uvm_object_utils(pwm_cnt_seq)

   timer_reg_block regmodel;

   rand bit [31:0] tcmp0_val; // period
   rand bit [31:0] tcmp1_val; // duty
   rand bit [31:0] tdr0_val; // pwm cnt
   rand bit div_mode;
   rand bit div_en;
   rand bit pwm_en;
   rand bit [3:0] div_val;
   rand bit [15:0] prescaler;
   rand bit int_en;

   constraint soft_c{
      soft div_mode == 1;
      soft prescaler == 0;
      soft int_en == 1;
      soft div_en == 1;
      soft pwm_en == 1;
   }

   constraint tcmp_val{
      if(div_val inside {[4'd5:4'd8]}) {
         tcmp0_val inside {[32'd1:32'd10]};
      }
      else {
         tcmp0_val inside {[32'd10:32'd200]};
      }
      tcmp1_val <= tcmp0_val;
   }

   function new(string name = "pwm_cnt_seq");
      super.new(name);
   endfunction

   virtual task body();
      uvm_status_e status;
      uvm_reg_data_t rdata;
      bit [31:0] tcr_val;

      if(regmodel==null) begin
         `uvm_fatal(get_type_name(),"regmodel is null, need assign regmoel before start")
      end

      `uvm_info(get_type_name(),$sformatf("Set config PWM MODE: TCMP0=%0h, TCMP1=%0h, pwm_en=%0h, div_en=%0h, div_val=%0h, div_mode=%0h, int_en=%0h",
                                                                tcmp0_val, tcmp1_val, pwm_en    , div_en    , div_val    , div_mode    , int_en    ),UVM_LOW)
      
      regmodel.TCMP0.write(status,tcmp0_val);
      regmodel.TCMP1.write(status,tcmp1_val);
      regmodel.TIER.write(status,{31'h0,int_en});

      tcr_val = {prescaler,4'b0,div_val,4'b0,div_mode,pwm_en,div_en,1'b1};
      regmodel.TCR.write(status,tcr_val);

      fork
         forever begin
	    #50ns;
	    regmodel.TISR.read(status,rdata);
	    if(rdata[1] == 1'b1) begin
	       `uvm_info(get_type_name(),"PWM Interrupt flag is asserted",UVM_LOW)
	       break;
	    end
	 end
	 begin
	    #1000us; // TIMEOUT
	    `uvm_error(get_type_name(),"PWM Interrupt flag is NOT asserted")
	 end
      join_any
      disable fork;

      regmodel.TDR0.read(status,tdr0_val);
      regmodel.TISR.write(status,32'h0000_0002);
      regmodel.TISR.read(status,rdata);
      if(rdata[1] == 1'b0) begin
         `uvm_info(get_type_name(),"PWM Interrupt flag is deleted to 0",UVM_LOW)
      end
      else begin
         `uvm_error(get_type_name(),"PWM Interrupt flag is NOT deleted !");
      end
   endtask
endclass
