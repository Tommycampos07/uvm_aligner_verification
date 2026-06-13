// Observa bus y genera objetos que necesiten otros componentes
class apb_monitor extends uvm_monitor;

  `uvm_component_utils(apb_monitor)

  virtual apb_if vif;

  uvm_analysis_port #(apb_item) ap;

  function new(string name = "apb_monitor", uvm_component parent = null);

    super.new(name, parent);

  endfunction

  virtual function void build_phase(uvm_phase phase);

    super.build_phase(phase);

    ap = new("ap", this);

    if (!uvm_config_db #(virtual apb_if)::get(this, "", "vif", vif)) begin

      `uvm_fatal("APB_MON", "Couldn't find apb_if from uvm_config_db")

    end

  endfunction

  virtual task run_phase(uvm_phase phase);

    apb_item item;

    wait (vif.reset_n === 1'b1);

    forever begin

      @(posedge vif.clk);

      if (vif.psel && vif.penable && vif.pready) begin

        item = apb_item::type_id::create("item");

        item.pwrite  = vif.pwrite;
        item.paddr   = vif.paddr;
        item.pwdata  = vif.pwdata;
        item.prdata  = vif.prdata;
        item.pslverr = vif.pslverr;

        ap.write(item);

        `uvm_info("APB_MON", $sformatf("APB transfer observed", item.convert2string()), UVM_LOW)

      end

    end
    
  endtask

endclass