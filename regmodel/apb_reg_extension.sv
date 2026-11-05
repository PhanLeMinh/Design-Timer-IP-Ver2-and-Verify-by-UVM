class apb_reg_extension extends uvm_object;
  `uvm_object_utils(apb_reg_extension)
  bit [3:0] pstrb = 4'hF;

  function new(string name = "apb_reg_extension");
     super.new(name);
  endfunction
endclass
