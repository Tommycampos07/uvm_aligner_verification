class aligner_virtualseq extends uvm_sequencer;

  `uvm_component_utils(aligner_virtualseq)

  uvm_sequencer #(apb_item) apb_seqr;

  function new(string name = "aligner_virtualseq",

               uvm_component parent = null);

    super.new(name, parent);

  endfunction

endclass