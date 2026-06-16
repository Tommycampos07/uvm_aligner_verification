class md_tx_driver extends uvm_driver #(md_item);

  `uvm_component_utils(md_tx_driver)

  virtual md_if #(32) vif;

  int unsigned tx_ready_mode;
  int unsigned tx_ready_high_cycles;
  int unsigned tx_ready_low_cycles;
  int unsigned tx_ready_random_pct;

  function new(string name = "md_tx_driver",
  
               uvm_component parent = null);
               
    super.new(name, parent);

    tx_ready_mode        = 0;
    tx_ready_high_cycles = 5;
    tx_ready_low_cycles  = 3;
    tx_ready_random_pct  = 70;

  endfunction

  virtual function void build_phase(uvm_phase phase);

    super.build_phase(phase);

    if (!uvm_config_db #(virtual md_if #(32))::get(this, "", "vif", vif)) begin

      `uvm_fatal("MD_TX_DRV", "Couldn't find md_tx_if from uvm_config_db")

    end

    void'($value$plusargs("TX_READY_MODE=%0d", tx_ready_mode));
    void'($value$plusargs("TX_READY_HIGH_CYCLES=%0d", tx_ready_high_cycles));
    void'($value$plusargs("TX_READY_LOW_CYCLES=%0d", tx_ready_low_cycles));
    void'($value$plusargs("TX_READY_RANDOM_PCT=%0d", tx_ready_random_pct));

    `uvm_info("MD_TX_DRV",

              $sformatf("TX ready configuration: MODE=%0d HIGH=%0d LOW=%0d RANDOM_PCT=%0d",
                        tx_ready_mode,
                        tx_ready_high_cycles,
                        tx_ready_low_cycles,
                        tx_ready_random_pct),
              UVM_LOW)

  endfunction

  virtual task run_phase(uvm_phase phase);

    vif.ready <= 1'b0;
    vif.err   <= 1'b0;

    wait (vif.reset_n === 1'b1);

    @(posedge vif.clk);

    case (tx_ready_mode)

      0: drive_always_ready();

      1: drive_periodic_backpressure();

      2: drive_random_backpressure();

      default: begin

        `uvm_warning("MD_TX_DRV",

                     $sformatf("Unknown TX_READY_MODE=%0d. Using always ready.",
                               tx_ready_mode))

        drive_always_ready();

      end

    endcase

  endtask

  virtual task drive_always_ready();

    `uvm_info("MD_TX_DRV", "Driving MD TX ready always high", UVM_LOW)

    forever begin

      @(posedge vif.clk);

      vif.ready <= 1'b1;
      vif.err   <= 1'b0;

    end

  endtask

  virtual task drive_periodic_backpressure();

    `uvm_info("MD_TX_DRV", "Driving periodic MD TX backpressure", UVM_LOW)

    forever begin

      repeat (tx_ready_high_cycles) begin

        @(posedge vif.clk);

        vif.ready <= 1'b1;
        vif.err   <= 1'b0;

      end

      repeat (tx_ready_low_cycles) begin

        @(posedge vif.clk);

        vif.ready <= 1'b0;
        vif.err   <= 1'b0;

      end

    end

  endtask

  virtual task drive_random_backpressure();

    int unsigned r;

    `uvm_info("MD_TX_DRV", "Driving random MD TX backpressure", UVM_LOW)

    forever begin

      @(posedge vif.clk);

      r = $urandom_range(0, 99);

      if (r < tx_ready_random_pct) begin

        vif.ready <= 1'b1;

      end

      else begin

        vif.ready <= 1'b0;

      end

      vif.err <= 1'b0;

    end

  endtask

endclass