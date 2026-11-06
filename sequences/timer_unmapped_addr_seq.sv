class  timer_unmapped_addr_seq extends uvm_sequence#(apb_transaction);
   `uvm_object_utils(timer_unmapped_addr_seq)

   function new(string name = "timer_unmapped_addr_seq");
      super.new(name);
   endfunction

   task write(input bit[11:0] addr,input bit[31:0] data,input bit[3:0] pstrb = 4'hF);
      req = apb_transaction::type_id::create("req");
      start_item(req);
      req.xact_type = apb_transaction::WRITE;
      req.addr      = addr;
      req.data      = data;
      req.pstrb     = pstrb;
      finish_item(req);
      get_response(rsp);
   endtask

   task read(input bit[11:0] addr,output bit[31:0] data);
      req = apb_transaction::type_id::create("req");
      start_item(req);
      req.xact_type = apb_transaction::READ;
      req.addr      = addr;
      req.pstrb     = 4'hF;
      finish_item(req);
      get_response(rsp);
      data          = rsp.data;
   endtask

   virtual task body();
       bit [31:0] rdata;

      write(12'h20 ,32'hABCD_ABCD);
      read(12'h20,rdata);
      if(rdata !== 32'h0) `uvm_error(get_type_name(),$sformatf("Unmapped read should return 0, got 0x%0h", rdata))

      write(12'h102,32'h5555_AAAA);
      read(12'h102,rdata);
      if(rdata !== 32'h0) `uvm_error(get_type_name(),$sformatf("Unmapped read should return 0, got 0x%0h", rdata))

      write(12'h001,32'h8888_BBBB);
      read(12'h001,rdata);
      if(rdata !== 32'h0) `uvm_error(get_type_name(),$sformatf("Unmapped read should return 0, got 0x%0h", rdata))

      write(12'h8F0,32'h0101_1010);
      read(12'h8F0,rdata);
      if(rdata !== 32'h0) `uvm_error(get_type_name(),$sformatf("Unmapped read should return 0, got 0x%0h", rdata))

      write(12'hFFF,32'h5555_5555);
      read(12'hFFF,rdata);
      if(rdata !== 32'h0) `uvm_error(get_type_name(),$sformatf("Unmapped read should return 0, got 0x%0h", rdata))
   endtask
endclass
