class apb_basic_seq extends uvm_sequence #(apb_item);

  `uvm_object_utils(apb_basic_seq)

  function new(string name = "apb_basic_seq");

    super.new(name);

  endfunction

  virtual task body();

    apb_item item;

    `uvm_info("APB_BASIC_SEQ", "Starting basic APB sequence", UVM_LOW)

    // WRITE CTRL: dirección 0x0000
    item = apb_item::type_id::create("write_ctrl_item");

    start_item(item);
    item.pwrite = 1'b1;
    item.paddr  = 16'h0000;
    item.pwdata = 32'h0000_0001; 
    finish_item(item);

    `uvm_info("APB_BASIC_SEQ", "WRITE CTRL transaction completed", UVM_LOW)

    // READ CTRL
    item = apb_item::type_id::create("read_ctrl_item");

    start_item(item);
    item.pwrite = 1'b0;
    item.paddr  = 16'h0000;
    item.pwdata = 32'h0000_0000;
    finish_item(item);

    `uvm_info("APB_BASIC_SEQ",

              $sformatf("READ CTRL recibido: prdata=0x%08h pslverr=%0b",
                        item.prdata, item.pslverr),
              UVM_LOW)

    // READ STATUS: dirección 0x000C
    item = apb_item::type_id::create("read_status_item");

    start_item(item);
    item.pwrite = 1'b0;
    item.paddr  = 16'h000C;
    item.pwdata = 32'h0000_0000;
    finish_item(item);

    `uvm_info("APB_BASIC_SEQ",
              $sformatf("READ STATUS recibido: prdata=0x%08h pslverr=%0b",
                        item.prdata, item.pslverr),
              UVM_LOW)

    `uvm_info("APB_BASIC_SEQ", "Basic APB sequence completed", UVM_LOW)

  endtask

endclass