class aligner_testbase extends uvm_test;

  `uvm_component_utils(aligner_testbase)

  aligner_env env;

  function new(string name = "aligner_base_test",

               uvm_component parent = null);

    super.new(name, parent);

  endfunction

  virtual function void build_phase(uvm_phase phase);

    super.build_phase(phase);

    env = aligner_env::type_id::create("env", this);

    `uvm_info("BASE_TEST", "aligner_testbase build_phase completed", UVM_LOW)

  endfunction

  virtual function void end_of_elaboration_phase(uvm_phase phase);

    super.end_of_elaboration_phase(phase);

    uvm_top.print_topology();

  endfunction

  virtual task run_phase(uvm_phase phase);

    apb_basic_seq apb_seq;

    phase.raise_objection(this);

    `uvm_info("TESTBASE", "Base test running", UVM_LOW)

    apb_seq = apb_basicseq::type_id::create("apb_seq")

    #100ns

    apb_seq.start(env.apb_agnt.seqr);

    #100ns

    phase.drop_objection(this);

  endtask

endclass