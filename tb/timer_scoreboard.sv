`uvm_analysis_imp_decl(_apb)

class timer_scoreboard extends uvm_scoreboard;
   `uvm_component_utils(timer_scoreboard)

   uvm_analysis_imp_apb#(apb_transaction,timer_scoreboard) apb_collect_export;

   apb_transaction trans_q[$];

   int pass_count;
   int fail_count;

   function new(string name = "timer_scoreboard",uvm_component parent);
      super.new(name,parent);
   endfunction

   virtual function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      apb_collect_export = new("apb_collect_export",this);
   endfunction

   virtual function void write_apb(apb_transaction apb_trans);
      trans_q.push_back(apb_trans);
      `uvm_info(get_type_name(),$sformatf("Scoreboard reveived: \n%0s",apb_trans.sprint()),UVM_HIGH)
   endfunction

   virtual function void check_phase(uvm_phase phase);
      super.check_phase(phase);
   endfunction
   virtual function void report_phase(uvm_phase phase);
      super.report_phase(phase);
   endfunction
endclass
