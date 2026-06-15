package aligner_pkg;

  import uvm_pkg::*;

  `include "uvm_macros.svh"

  
  `uvm_analysis_imp_decl(_rx)
  `uvm_analysis_imp_decl(_expected)
  `uvm_analysis_imp_decl(_actual)


  `include "agents/apb/apb_item.sv"
  `include "agents/apb/apb_driver.sv"
  `include "agents/apb/apb_monitor.sv"
  `include "agents/apb/apb_agent.sv"

  `include "agents/md/md_item.sv"
  `include "agents/md/md_rx_driver.sv"
  `include "agents/md/md_rx_monitor.sv"
  `include "agents/md/md_rx_agent.sv"
  `include "agents/md/md_tx_driver.sv"
  `include "agents/md/md_tx_monitor.sv"
  `include "agents/md/md_tx_agent.sv"

  `include "seqs/apb_basic_seq.sv"

  `include "ral/aligner_apb_adapter.sv"
  `include "ral/aligner_reg_block.sv"

  `include "env/aligner_virtualseq.sv"

  `include "seqs/apb_basic_seq.sv"
  `include "seqs/ral_basic_vseq.sv"

  `include "env/aligner_reference_model.sv"
  `include "env/aligner_scoreboard.sv"
  `include "env/aligner_env.sv"

  `include "tests/aligner_testbase.sv"

endpackage