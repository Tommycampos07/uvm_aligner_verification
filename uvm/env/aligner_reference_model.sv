class aligner_reference_model extends uvm_component;

  `uvm_component_utils(aligner_reference_model)

  uvm_analysis_imp_rx #(md_item, aligner_reference_model) rx_export;

  uvm_analysis_port #(md_item) expected_ap;

  function new(string name = "aligner_reference_model",

               uvm_component parent = null);

    super.new(name, parent);

  endfunction

  virtual function void build_phase(uvm_phase phase);

    super.build_phase(phase);

    rx_export   = new("rx_export", this);
    expected_ap = new("expected_ap", this);

    `uvm_info("REF_MODEL", "Reference model build_phase completed", UVM_LOW)

  endfunction

  virtual function void write_rx(md_item item);

    `uvm_info("REF_MODEL",
    
              $sformatf("RX recibido por reference model: data=0x%08h offset=%0d size=%0d err=%0b",
                        item.data, item.offset, item.size, item.err),
              UVM_LOW)

  endfunction

endclass