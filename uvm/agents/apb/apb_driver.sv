// Conduce objetos del sequencer al dut mediante vif
class apb_driver extends uvm_driver #(apb_item);

  `uvm_component_utils(apb_driver)

  virtual apb_if vif;

  function new(string name = "apb_driver", uvm_component parent = null);

    super.new(name, parent);

  endfunction

  virtual function void build_phase(uvm_phase phase);

    super.build_phase(phase);

    if (!uvm_config_db #(virtual apb_if)::get(this, "", "vif", vif)) begin

      `uvm_fatal("APB_DRV", "No se pudo obtener apb_if desde uvm_config_db")

    end

  endfunction

  virtual task run_phase(uvm_phase phase);
    apb_item req;

    // Estado inicial seguro
    vif.psel    <= 1'b0;
    vif.penable <= 1'b0;
    vif.pwrite  <= 1'b0;
    vif.paddr   <= '0;
    vif.pwdata  <= '0;

    forever begin
        
      seq_item_port.get_next_item(req);

      `uvm_info("APB_DRV", $sformatf("Recibi item APB: %s", req.convert2string()), UVM_LOW)

      // Por ahora no manejamos el protocolo real.
      // Luego aquí implementaremos write/read APB.

      seq_item_port.item_done();
    end
  endtask

endclass