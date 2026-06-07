`timescale 1ns/1ps

// Modulo con dut, clk, instancias if (guardadas en uvm_config_db), llamada test
module tb_top;

  import uvm_pkg::*;
  import aligner_pkg::*;

  `include "uvm_macros.svh"

  localparam int ALGN_DATA_WIDTH = 32;
  localparam int FIFO_DEPTH      = 8;

  logic clk;
  logic reset_n;
  logic irq;

  // Clock
  initial clk = 1'b0;
  always #5 clk = ~clk;

  // Reset
  initial begin

    reset_n = 1'b0;
    repeat (5) @(posedge clk);
    reset_n = 1'b1;

  end

  // Interfaces
  apb_if apb_vif (

    .clk     (clk),
    .reset_n (reset_n)

  );

  md_if #(.DATA_WIDTH(ALGN_DATA_WIDTH)) 
  
  md_rx_vif (

    .clk     (clk),
    .reset_n (reset_n)

  );

  md_if #(.DATA_WIDTH(ALGN_DATA_WIDTH)) 
  
  md_tx_vif (

    .clk     (clk),
    .reset_n (reset_n)

  );

  // DUT
  cfs_aligner #(

    .ALGN_DATA_WIDTH(ALGN_DATA_WIDTH),
    .FIFO_DEPTH     (FIFO_DEPTH)
  ) 
  
  dut (

    .clk     (clk),
    .reset_n (reset_n),

    // apb
    .psel    (apb_vif.psel),
    .penable (apb_vif.penable),
    .pwrite  (apb_vif.pwrite),
    .paddr   (apb_vif.paddr),
    .pwdata  (apb_vif.pwdata),
    .pready  (apb_vif.pready),
    .prdata  (apb_vif.prdata),
    .pslverr (apb_vif.pslverr),

    // md rx
    .md_rx_valid  (md_rx_vif.valid),
    .md_rx_data   (md_rx_vif.data),
    .md_rx_offset (md_rx_vif.offset),
    .md_rx_size   (md_rx_vif.size),
    .md_rx_ready  (md_rx_vif.ready),
    .md_rx_err    (md_rx_vif.err),

    // md tx
    .md_tx_valid  (md_tx_vif.valid),
    .md_tx_data   (md_tx_vif.data),
    .md_tx_offset (md_tx_vif.offset),
    .md_tx_size   (md_tx_vif.size),
    .md_tx_ready  (md_tx_vif.ready),
    .md_tx_err    (md_tx_vif.err),

    // IRQ
    .irq (irq)

  );

  // Inicialización de señales conducidas por el TB
  initial begin

    apb_vif.psel    = 1'b0;
    apb_vif.penable = 1'b0;
    apb_vif.pwrite  = 1'b0;
    apb_vif.paddr   = '0;
    apb_vif.pwdata  = '0;

    md_rx_vif.valid  = 1'b0;
    md_rx_vif.data   = '0;
    md_rx_vif.offset = '0;
    md_rx_vif.size   = '0;

    md_tx_vif.ready = 1'b0;
    md_tx_vif.err   = 1'b0;

  end

  // Pasar virtual interfaces a UVM
  initial begin

    uvm_config_db #(virtual apb_if)::set(

      null,
      "uvm_test_top.env.apb_agent*",
      "vif",
      apb_vif

    );

    uvm_config_db #(virtual md_if #(ALGN_DATA_WIDTH))::set(

      null,
      "uvm_test_top.env.md_rx_agent*",
      "vif",
      md_rx_vif

    );

    uvm_config_db #(virtual md_if #(ALGN_DATA_WIDTH))::set(

      null,
      "uvm_test_top.env.md_tx_agent*",
      "vif",
      md_tx_vif

    );

    run_test("aligner_testbase");
  end

endmodule