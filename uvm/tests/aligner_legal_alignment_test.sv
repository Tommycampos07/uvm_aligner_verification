class aligner_legal_alignment_test extends aligner_testbase;

  `uvm_component_utils(aligner_legal_alignment_test)

  function new(string name = "aligner_legal_alignment_test",

               uvm_component parent = null);

    super.new(name, parent);

  endfunction

  virtual task run_phase(uvm_phase phase);

    legal_alignment_vseq legal_seq;

    phase.raise_objection(this);

    `uvm_info("LEGAL_ALIGNMENT_TEST", "Starting legal alignment test", UVM_LOW)

    #100ns;

    legal_seq = legal_alignment_vseq::type_id::create("legal_seq");

    `uvm_info("LEGAL_ALIGNMENT_TEST",
    
              "Starting legal_alignment_vseq on virtual sequencer",
              UVM_LOW)

    legal_seq.start(env.vseqr);

    `uvm_info("LEGAL_ALIGNMENT_TEST",
              "legal_alignment_vseq completed",
              UVM_LOW)

    #100ns;

    `uvm_info("LEGAL_ALIGNMENT_TEST", "Finishing legal alignment test", UVM_LOW)

    phase.drop_objection(this);

  endtask

endclass