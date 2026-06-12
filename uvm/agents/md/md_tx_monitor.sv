class md_tx_monitor extends uvm_monitor;

  `uvm_component_utils(md_tx_monitor)

  virtual md_if #(32) vif;

  uvm_analysis_port #(md_item) ap;

  function new(string name = "md_tx_monitor", uvm_component parent = null);

    super.new(name, parent);

  endfunction

  virtual function void build_phase(uvm_phase phase);

    super.build_phase(phase);

    ap = new("ap", this);

    if (!uvm_config_db #(virtual md_if #(32))::get(this, "", "vif", vif)) begin

      `uvm_fatal("MD_TX_MON", "No se pudo obtener md_tx_if desde uvm_config_db")

    end
  endfunction

  virtual task run_phase(uvm_phase phase);

    md_item item;

    @(posedge vif.reset_n);

    forever begin

      @(posedge vif.clk);

      if (vif.valid && vif.ready) begin

        item = md_item::type_id::create("item");

        item.data   = vif.data;
        item.offset = vif.offset;
        item.size   = vif.size;
        item.err    = vif.err;

        ap.write(item);

        `uvm_info("MD_TX_MON",
                  $sformatf("MD TX observado: data=0x%08h offset=%0d size=%0d err=%0b",
                            item.data, item.offset, item.size, item.err),
                  UVM_LOW)
      end
    end
  endtask

endclass