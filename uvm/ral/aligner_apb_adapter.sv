class aligner_apb_adapter extends uvm_reg_adapter;

  `uvm_object_utils(aligner_apb_adapter)

  function new(string name = "aligner_apb_adapter");

    super.new(name);

    // El driver APB devuelve respuesta en el mismo item
    supports_byte_enable = 0;
    provides_responses   = 0;
  endfunction

  virtual function uvm_sequence_item reg2bus(const ref uvm_reg_bus_op rw);

    apb_item item;

    item = apb_item::type_id::create("item");

    item.pwrite = (rw.kind == UVM_WRITE);
    item.paddr  = rw.addr[15:0];
    item.pwdata = rw.data[31:0];

    return item;

  endfunction

  virtual function void bus2reg(uvm_sequence_item bus_item,
                                ref uvm_reg_bus_op rw);

    apb_item item;

    if (!$cast(item, bus_item)) begin

      `uvm_fatal("APB_ADAPTER", "bus_item is not an apb_item")
      
    end

    rw.kind   = item.pwrite ? UVM_WRITE : UVM_READ;
    rw.addr   = item.paddr;
    rw.data   = item.pwrite ? item.pwdata : item.prdata;
    rw.status = item.pslverr ? UVM_NOT_OK : UVM_IS_OK;

  endfunction

endclass