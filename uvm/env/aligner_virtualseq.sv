class aligner_virtualseq extends uvm_sequencer;

  `uvm_component_utils(aligner_virtualseq)

  uvm_sequencer #(apb_item) apb_seqr;
  uvm_sequencer #(md_item) md_rx_seqr;
  uvm_sequencer #(md_item) md_tx_seqr;

  aligner_reg_block ral_model;

  function new(string name = "aligner_virtualseq",

               uvm_component parent = null);

    super.new(name, parent);

  endfunction

endclass