class timer_cnt_seq extends uvm_sequence;
   `uvm_object_utils(timer_cnt_seq)

   timer_reg_block regmodel;

   rand bit [31:0] tcmp0_val;
   rand bit [31:0] tcmp1_val;
   rand bit div_mode;
   rand bit div_en;
   rand bit [3:0] div_val;
   rand bit [15:0] prescaler;
   rand bit int_en;

   constraint div_val_c {
      div_val inside {[4'd0:4'd8]};
   }
   
   constraint tcmp_c {
      if(div_val inside {[4'd0:4'd4]}) 
         tcmp0_val inside {[32'd1:32'd100]};
      else 
        tcmp0_val inside {[32'd1:32'd5]};
   }

   constraint tcmp1_val_c{
      soft tcmp1_val == 32'h0;
   }


   constraint c_default {
      soft div_en == 1;
      soft int_en == 1; // set interrupt
      soft div_mode == 0;
   }


   function new(string name = "timer_cnt_seq");
      super.new(name);
   endfunction

   virtual task body();
      uvm_status_e status;
      uvm_reg_data_t rdata;
      bit [31:0] tcr_val;

      if(regmodel==null) begin 
         `uvm_fatal(get_type_name(),"regmodel is null, need assign regmodel before start")
      end

      `uvm_info(get_type_name(),$sformatf("Set config TIMER MODE: TCMP0=%0h, div_en=%0h, div_val=%0h, div_mode=%0h, int_en=%0h",tcmp0_val,div_en,div_val,div_mode,int_en),UVM_LOW)

      regmodel.TCMP0.write(status,tcmp0_val);
      regmodel.TCMP1.write(status,tcmp1_val);
      regmodel.TIER.write(status,{30'h0,int_en});

      tcr_val = {prescaler,4'b0,div_val,4'b0,1'b0,div_mode,div_en,1'b1};
      regmodel.TCR.write(status,tcr_val);

      fork
         begin
	   forever begin
	      #5ns;
	      regmodel.TISR.read(status,rdata);
	      if(rdata[0] == 1'b1) begin
	         `uvm_info(get_type_name(),"Interrupt flag is asserted",UVM_LOW)
		 break;
	      end
	   end
         end

	 begin
	    // TIME OUT
	    #20000ns;
	    `uvm_error(get_type_name(),"Interrupt flag is NOT asserted")
	 end
      join_any
      disable fork;

      regmodel.TISR.write(status,32'h0000_0001); // Write 1 to clear interrupt
      regmodel.TISR.read(status,rdata);
      if(rdata == 1'b0) begin
         `uvm_info(get_type_name(),"Interrupt flag is deleted to 0",UVM_LOW)
      end
      else begin
         `uvm_error(get_type_name(),"Interrupt flag is NOT deleted")
      end
      regmodel.TCR.write(status,tcr_val & ~32'h1);
      regmodel.TCR.write(status,32'h0);
      #20ns;

   endtask
endclass
