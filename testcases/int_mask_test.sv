class int_mask_test extends apb_base_test;
    `uvm_component_utils(int_mask_test)

    timer_cnt_seq timer_seq;

    function new(string name = "int_mask_test",uvm_component parent);
       super.new(name,parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
       super.build_phase(phase);
       timer_seq = timer_cnt_seq::type_id::create("timer_cnt_seq");
       if(!timer_seq.randomize() with {int_en==0;div_val==0;})
          `uvm_fatal(get_type_name(),"Failed randomize timer_cnt_seq!!!")
    endfunction 

    virtual task run_phase(uvm_phase phase);
       phase.raise_objection(this);

       timer_seq.regmodel = timer_env.reg_model;
       fork 
          begin
	     timer_seq.start(null);
	  end
	  begin
	     forever begin
	        @(timer_vif.tim_int);
	        if(timer_vif.tim_int === 1'b1)
	           `uvm_error(get_type_name(),"TEST FAILED: tim_int asserted while int_en == 0 (interrupt is masked)!")
             end
	  end
       join_any
       disable fork;

       if(timer_vif.tim_int !== 1'b0) begin
          `uvm_error(get_type_name(),"TEST FAILED: tim_int is 1, expected 0")
       end
       else begin
          `uvm_info(get_type_name(), "TEST PASSED: int_st was set but tim_int remained 0 as expected!", UVM_LOW)
       end

       phase.drop_objection(this);
    endtask
endclass
