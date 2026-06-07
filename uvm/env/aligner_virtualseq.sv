class aligner_virtual_sequencer extends uvm_sequencer;

  `uvm_component_utils(aligner_virtual_sequencer)

  function new(string name = "aligner_virtual_sequencer",

               uvm_component parent = null);

    super.new(name, parent);
    
  endfunction

endclass