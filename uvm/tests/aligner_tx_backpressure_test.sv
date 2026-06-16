class aligner_tx_backpressure_test extends aligner_testbase;

  `uvm_component_utils(aligner_tx_backpressure_test)

  function new(string name = "aligner_tx_backpressure_test",
               uvm_component parent = null);

    super.new(name, parent);

  endfunction

  virtual task run_phase(uvm_phase phase);

    legal_alignment_vseq legal_seq;

    phase.raise_objection(this);

    `uvm_info("TX_BACKPRESSURE_TEST", "Starting TX backpressure test", UVM_LOW)

    #100ns;

    legal_seq = legal_alignment_vseq::type_id::create("legal_seq");

    legal_seq.start(env.vseqr);

    `uvm_info("TX_BACKPRESSURE_TEST", "TX backpressure test completed", UVM_LOW)

    #300ns;

    phase.drop_objection(this);

  endtask

endclass