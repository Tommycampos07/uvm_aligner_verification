class md_item extends uvm_sequence_item;

  rand bit [31:0] data;
  rand bit [1:0]  offset;
  rand bit [2:0]  size;
       bit        err;

  `uvm_object_utils_begin(md_item)
    `uvm_field_int(data,   UVM_DEFAULT | UVM_HEX)
    `uvm_field_int(offset, UVM_DEFAULT)
    `uvm_field_int(size,   UVM_DEFAULT)
    `uvm_field_int(err,    UVM_DEFAULT)
  `uvm_object_utils_end

  function new(string name = "md_item");

    super.new(name);
    
  endfunction

endclass