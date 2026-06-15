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

    apb_basic_seq apb_seq;

    phase.raise_objection(this);

    `uvm_info("TESTBASE", "Base test running", UVM_LOW)

    apb_seq = apb_basicseq::type_id::create("apb_seq")

    `uvm_info("TESTBASE", "Starting apb_basic_seq on APB sequencer", UVM_LOW)

    apb_seq.start(env.apb_agnt.seqr);

    `uvm_info("TESTBASE", "apb_basic_seq completed", UVM_LOW)

    #100ns

    `uvm_info("TESTBASE", "Finishing APB infrastructure", UVM_LOW)

    phase.drop_objection(this);

  endtask

endclass