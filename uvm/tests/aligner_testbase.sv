class aligner_testbase extends uvm_test;

  `uvm_component_utils(aligner_testbase)

  aligner_env env;

  function new(string name = "aligner_testbase",

               uvm_component parent = null);

    super.new(name, parent);

  endfunction

  virtual function void build_phase(uvm_phase phase);

    super.build_phase(phase);

    env = aligner_env::type_id::create("env", this);

    `uvm_info("TESTBASE", "aligner_testbase build_phase completed", UVM_LOW)

  endfunction

  virtual function void end_of_elaboration_phase(uvm_phase phase);

    super.end_of_elaboration_phase(phase);

    `uvm_info("TESTBASE", "Printing UVM topology", UVM_LOW)

    uvm_top.print_topology();

  endfunction

  virtual task run_phase(uvm_phase phase);

    legal_alignment_vseq legal_seq;

    phase.raise_objection(this);

    `uvm_info("TESTBASE", "Starting legal alignment smoke test", UVM_LOW)

    #100ns;

    legal_seq = legal_alignment_vseq::type_id::create("legal_seq");

    `uvm_info("TESTBASE", "Starting legal_alignment_vseq on virtual sequencer", UVM_LOW)

    legal_seq.start(env.vseqr);

    `uvm_info("TESTBASE", "legal_alignment_vseq completed", UVM_LOW)

    #100ns;

    `uvm_info("TESTBASE", "Finishing legal alignment smoke test", UVM_LOW)

    phase.drop_objection(this);

  endtask

endclass