class aligner_reg_32 extends uvm_reg;

  `uvm_object_utils(aligner_reg_32)

  rand uvm_reg_field value;

  function new(string name = "aligner_reg_32");

    super.new(name, 32, UVM_NO_COVERAGE);

  endfunction

  virtual function void build();

    value = uvm_reg_field::type_id::create("value");

    value.configure(
      this,
      32,       // size
      0,        // lsb_pos
      "RW",     // access
      0,        // volatile
      32'h0,    // reset
      1,        // has_reset
      1,        // is_rand
      0         // individually_accessible
    );

  endfunction

endclass

class aligner_reg_block extends uvm_reg_block;

  `uvm_object_utils(aligner_reg_block)

  rand aligner_reg_32 CTRL;
  rand aligner_reg_32 STATUS;
  rand aligner_reg_32 IRQEN;
  rand aligner_reg_32 IRQ;

  uvm_reg_map apb_map;

  function new(string name = "aligner_reg_block");

    super.new(name, UVM_NO_COVERAGE);

  endfunction

  virtual function void build();

    CTRL = aligner_reg_32::type_id::create("CTRL");
    CTRL.configure(this, null, "");
    CTRL.build();

    STATUS = aligner_reg_32::type_id::create("STATUS");
    STATUS.configure(this, null, "");
    STATUS.build();

    IRQEN = aligner_reg_32::type_id::create("IRQEN");
    IRQEN.configure(this, null, "");
    IRQEN.build();

    IRQ = aligner_reg_32::type_id::create("IRQ");
    IRQ.configure(this, null, "");
    IRQ.build();

    apb_map = create_map(

      "apb_map",
      'h0,          // base address
      4,            // bytes per address
      UVM_LITTLE_ENDIAN
      
    );

    apb_map.add_reg(CTRL,   'h0000, "RW");
    apb_map.add_reg(STATUS, 'h000C, "RO");
    apb_map.add_reg(IRQEN,  'h00F0, "RW");
    apb_map.add_reg(IRQ,    'h00F4, "RW");

    lock_model();

  endfunction

endclass