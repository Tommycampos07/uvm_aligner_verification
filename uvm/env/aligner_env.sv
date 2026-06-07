class aligner_env extends uvm_env;

  `uvm_component_utils(aligner_env)

  aligner_virtual_sequencer vseqr;

  function new(string name = "aligner_env",

               uvm_component parent = null);

    super.new(name, parent);

  endfunction

  virtual function void build_phase(uvm_phase phase);

    super.build_phase(phase);

    vseqr = aligner_virtual_sequencer::type_id::create("vseqr", this);

    `uvm_info("ENV", "aligner_env build_phase completed", UVM_LOW)

  endfunction

  virtual function void connect_phase(uvm_phase phase);
    
    super.connect_phase(phase);

    `uvm_info("ENV", "aligner_env connect_phase completed", UVM_LOW)
  endfunction

endclass