class md_tx_agent extends uvm_agent;

  `uvm_component_utils(md_tx_agent)

  uvm_sequencer #(md_item) seqr;
  md_tx_driver              drv;
  md_tx_monitor             mon;

  function new(string name = "md_tx_agent", uvm_component parent = null);

    super.new(name, parent);

  endfunction

  virtual function void build_phase(uvm_phase phase);

    super.build_phase(phase);

    mon = md_tx_monitor::type_id::create("mon", this);

    if (get_is_active() == UVM_ACTIVE) begin

      seqr = uvm_sequencer #(md_item)::type_id::create("seqr", this);
      drv  = md_tx_driver::type_id::create("drv", this);

    end
  endfunction

  virtual function void connect_phase(uvm_phase phase);

    super.connect_phase(phase);

    if (get_is_active() == UVM_ACTIVE) begin
      drv.seq_item_port.connect(seqr.seq_item_export);
      
    end
  endfunction

endclass