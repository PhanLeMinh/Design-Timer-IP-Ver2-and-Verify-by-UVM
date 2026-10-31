class timer_cnt_rand_pre_seq extends uvm_sequence;
   `uvm_object_utils(timer_cnt_rand_pre_seq)

   timer_reg_block regmodel;

   rand bit [31:0] tcmp0_val;
   rand bit [31:0] tcmp1_val;
   rand bit [15:0] prescaler;
   rand bit div_mode;
   rand bit int_en;
   rand bit div_en;
   rand bit [3:0] div_val;

   constraint soft_c{
      soft div_mode == 1'b1;
      soft int_en   == 1'b1;
      soft div_en   == 1'b1;
      soft div_val  == 4'b0;
      soft tcmp1_val== 32'h0;
   }

   constraint prescaler_c{
      prescaler dist{
         16'd0              := 5,
	 16'd1              := 5,
	 [16'd2  :16'd15]   := 40,
	 [16'd16 :16'd255]  := 35,
	 [16'd256:16'd1024] := 14,
	 16'hFFFF           := 1
      };
   }

   constraint tcmp0_val_c{
      if(prescaler > 16'd255) 
         tcmp0_val inside {[32'd1:32'd5]};
      else
         tcmp0_val inside {[32'd5:32'd50]};
   }

   local string msg = "TIMER_RANDOM_PRESCALER_SEQUENCE";

   function new(string name = "timer_cnt_rand_pre_seq");
      super.new(name);
   endfunction

   virtual task body();
      uvm_status_e status;
      uvm_reg_data_t rdata;
      bit [31:0] tcr_val;

      if(regmodel==null) begin
         `uvm_fatal(msg,"regmodel is null, need assign regmodel before start");
      end
      regmodel.TCMP0.write(status,tcmp0_val);
      regmodel.TCMP1.write(status,tcmp1_val);
      regmodel.TIER.write(status,{31'h0,int_en});
      
      tcr_val = {prescaler,4'b0,div_val,4'b0,1'b0,div_mode,div_en,1'b1};
      regmodel.TCR.write(status,tcr_val);

      fork
         forever begin
	    #50ns;
	    regmodel.TISR.read(status,rdata);
	    if(rdata[0] == 1'b1) begin
	       `uvm_info(msg,"Timer interrupt is asserted",UVM_LOW)
	       break;
	    end
	 end
	 begin
	    #800us;
	    `uvm_fatal(msg,"Timer interrupt is NOT asserted")
	 end
      join_any
      disable fork;

      regmodel.TISR.write(status,{31'h0,1'b1});
      regmodel.TISR.read(status,rdata);
      if(rdata[0] == 1'b0) begin
         `uvm_info(msg,"Timer interrupt is deleted to 0",UVM_LOW)
      end else begin
         `uvm_error(msg,"Timer interrupt is NOT deleted!!!")
      end

   endtask
endclass
