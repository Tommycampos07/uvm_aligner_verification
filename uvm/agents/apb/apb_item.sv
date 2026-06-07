// Sequence item encargado de representar transacción apb a lvl objeto
class apb_item extends uvm_sequence_item;

  rand bit        pwrite;
  rand bit [15:0] paddr;
  rand bit [31:0] pwdata;
       bit [31:0] prdata;
       bit        pslverr;

  `uvm_object_utils_begin(apb_item)

    `uvm_field_int(pwrite,  UVM_DEFAULT)
    `uvm_field_int(paddr,   UVM_DEFAULT | UVM_HEX)
    `uvm_field_int(pwdata,  UVM_DEFAULT | UVM_HEX)
    `uvm_field_int(prdata,  UVM_DEFAULT | UVM_HEX)
    `uvm_field_int(pslverr, UVM_DEFAULT)
  `uvm_object_utils_end

  function new(string name = "apb_item");

    super.new(name);

  endfunction

endclass