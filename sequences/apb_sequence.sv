class apb_sequence extends uvm_sequence#(apb_transaction);
   `uvm_object_utils(apb_sequence)

   function new(string name = "apb_sequence");
      super.new(name);
   endfunction

   virtual task body();
      req = apb_transaction::type_id::create("req");
      start_item(req);
      assert(req.randomize()) else `uvm_fatal(get_type_name(),"Failed to randomize apb_transaction")
      `uvm_info(get_type_name(),$sformatf("Sending transaction: \n%0s",req.sprint()),UVM_LOW)
      finish_item(req);
   endtask
endclass
