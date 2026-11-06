class apb_base_test extends uvm_test;
   `uvm_component_utils(apb_base_test)

   virtual apb_if apb_vif;
   virtual timer_if timer_vif;
   apb_configuration apb_cfg;

   timer_environment timer_env;

   function new(string name = "apb_base_test", uvm_component parent);
      super.new(name,parent);
   endfunction

   virtual function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      if(!uvm_config_db#(virtual apb_if)::get(this,"","apb_vif",apb_vif))
         `uvm_fatal(get_type_name(),"Failed to get apb_vif from uvm_config_db")
      if(!uvm_config_db#(virtual timer_if)::get(this,"","timer_vif",timer_vif))
         `uvm_fatal(get_type_name(),"Failed to get timer_vif from uvm_config_db")
      if(!uvm_config_db#(apb_configuration)::get(this,"","apb_cfg",apb_cfg))
         `uvm_fatal(get_type_name(),"Failed to get apb_cfg from uvm_config_db")

      apb_cfg = apb_configuration::type_id::create("apb_cfg");
      assert(apb_cfg.randomize()) else `uvm_fatal(get_type_name(),"Failed to rendomize apb_cfg")

      timer_env = timer_environment::type_id::create("timer_env",this);

      uvm_config_db#(virtual apb_if)::set(this,"timer_env","apb_vif",apb_vif);
      uvm_config_db#(virtual timer_if)::set(this,"timer_env","timer_vif",timer_vif);
      uvm_config_db#(apb_configuration)::set(this,"timer_env","apb_cfg",apb_cfg);

   endfunction

   task write_reg_strobe(uvm_reg rg, bit [31:0] data, bit [3:0] pstrb);
       apb_reg_extension ext;
       uvm_status_e status;

       ext = new();
       ext.pstrb = pstrb;
       rg.write(status, data, .extension(ext));
   endtask
   
   virtual function void start_of_simulation_phase(uvm_phase phase);
      `uvm_info(get_type_name(),"Start_of_simulation_phase: Entered...", UVM_HIGH)
      uvm_top.print_topology();
      `uvm_info(get_type_name(),"Start_of_simulation_phase: Exiting...", UVM_HIGH)
   endfunction

   virtual function void final_phase(uvm_phase phase);
      uvm_report_server srv;
        super.final_phase(phase);
        `uvm_info("final_phase","Entered...",UVM_HIGH)
        srv = uvm_report_server::get_server();
        if(srv.get_severity_count(UVM_FATAL) + srv.get_severity_count(UVM_ERROR) > 0) begin
            $display("\n\033[31m===========================================================");
            $display("             ##### Status: TEST FAILED #####         ");
            $display("===========================================================\033[0m\n");
        end
        else begin
            $display("\n\033[32m==========================================================");
            $display("              ##### Status: TEST PASSED #####          ");
            $display("===========================================================\033[0m\n");
        end

        `uvm_info("final_phase","Exiting...",UVM_HIGH)
   endfunction

endclass
