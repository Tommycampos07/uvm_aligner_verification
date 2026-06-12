class md_tx_driver extends uvm_driver #(md_item);

  `uvm_component_utils(md_tx_driver)

  virtual md_if #(32) vif;

  function new(string name = "md_tx_driver", uvm_component parent = null);

    super.new(name, parent);

  endfunction

  virtual function void build_phase(uvm_phase phase);

    super.build_phase(phase);

    if (!uvm_config_db #(virtual md_if #(32))::get(this, "", "vif", vif)) begin

      `uvm_fatal("MD_TX_DRV", "No se pudo obtener md_tx_if desde uvm_config_db")

    end
  endfunction

  virtual task run_phase(uvm_phase phase);

    // Estado para prueba general: siempre listo, sin error externo
    vif.ready <= 1'b0;
    vif.err   <= 1'b0;

    @(posedge vif.reset_n);

    vif.ready <= 1'b1;
    vif.err   <= 1'b0;

    forever begin

      @(posedge vif.clk);
      
    end
  endtask

endclass