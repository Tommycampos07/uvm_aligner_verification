class md_rx_driver extends uvm_driver #(md_item);

  `uvm_component_utils(md_rx_driver)

  virtual md_if #(32) vif;

  function new(string name = "md_rx_driver", uvm_component parent = null);

    super.new(name, parent);

  endfunction

  virtual function void build_phase(uvm_phase phase);

    super.build_phase(phase);

    if (!uvm_config_db #(virtual md_if #(32))::get(this, "", "vif", vif)) begin

      `uvm_fatal("MD_RX_DRV", "No se pudo obtener md_rx_if desde uvm_config_db")

    end
  endfunction

  virtual task run_phase(uvm_phase phase);

    md_item req;

    // Estado inicial seguro
    vif.valid  <= 1'b0;
    vif.data   <= '0;
    vif.offset <= '0;
    vif.size   <= '0;

    // Esperar salida de reset
    @(posedge vif.reset_n);

    forever begin

      seq_item_port.get_next_item(req);

      @(posedge vif.clk);

      vif.valid  <= 1'b1;
      vif.data   <= req.data;
      vif.offset <= req.offset;
      vif.size   <= req.size;

      //Mantener estable hasta que el DUT acepte
      do begin

        @(posedge vif.clk);

      end while (!vif.ready);

      //Transferencia aceptada valid && ready
      vif.valid  <= 1'b0;
      vif.data   <= '0;
      vif.offset <= '0;
      vif.size   <= '0;

      `uvm_info("MD_RX_DRV",

                $sformatf("MD RX item enviado: data=0x%08h offset=%0d size=%0d",
                          req.data, req.offset, req.size),
                UVM_LOW)

      seq_item_port.item_done();
      
    end
  endtask

endclass