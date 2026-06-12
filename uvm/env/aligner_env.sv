class aligner_env extends uvm_env;

  `uvm_component_utils(aligner_env)

  aligner_virtualseq vseqr;

  apb_agent apb_agnt;
  md_rx_agent md_rx_agnt;
  md_tx_agent md_tx_agnt;

  function new(string name = "aligner_env",

               uvm_component parent = null);

    super.new(name, parent);

  endfunction

  virtual function void build_phase(uvm_phase phase);

    super.build_phase(phase);

    vseqr = aligner_virtualseq::type_id::create("vseqr", this);
    apb_agnt = apb_agent::type_id::create("apb_agnt", this);
    md_rx_agent = md_rx_agent::type_id::create("md_rx_agnt", this)
    md_tx_agent = md_tx_agent::type_id::create("md_tx_agnt", this)


    `uvm_info("ENV", "aligner_env build_phase completed", UVM_LOW)

  endfunction

  virtual function void connect_phase(uvm_phase phase);

    super.connect_phase(phase);

    vseqr.apb_seqr = apb_agnt.seqr;
    vseqr.md_rx_seqr = md_rx_agnt.seqr;
    vseqr.md_tx_seqr = md_tx_agnt.seqr;

    `uvm_info("ENV", "aligner_env connect_phase completed", UVM_LOW)
  endfunction

endclass