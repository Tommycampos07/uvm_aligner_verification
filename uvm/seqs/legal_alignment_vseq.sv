class legal_alignment_vseq extends uvm_sequence;

  `uvm_object_utils(legal_alignment_vseq)
  `uvm_declare_p_sequencer(aligner_virtualseq)

  function new(string name = "legal_alignment_vseq");

    super.new(name);

  endfunction

  virtual task body();

    uvm_status_e   status;
    uvm_reg_data_t data;
    int unsigned drain_time_ns;

    md_rx_basic_seq md_seq;

    `uvm_info("LEGAL_ALIGNMENT_VSEQ", "Starting legal alignment virtual sequence", UVM_LOW)

    if (p_sequencer.ral_model == null) begin

      `uvm_fatal("LEGAL_ALIGNMENT_VSEQ", "RAL model handle is null")

    end

    if (p_sequencer.md_rx_seqr == null) begin

      `uvm_fatal("LEGAL_ALIGNMENT_VSEQ", "MD RX sequencer handle is null")

    end

    `uvm_info("LEGAL_ALIGNMENT_VSEQ", "Configuring CTRL register through RAL", UVM_LOW)

    p_sequencer.ral_model.CTRL.write(
      status,
      32'h0000_0001,
      UVM_FRONTDOOR
    );

    if (status != UVM_IS_OK) begin

      `uvm_error("LEGAL_ALIGNMENT_VSEQ", "CTRL write failed")

    end

    else begin

      `uvm_info("LEGAL_ALIGNMENT_VSEQ", "CTRL write completed", UVM_LOW)

    end

    //readback por si acaso
    p_sequencer.ral_model.CTRL.read(
      status,
      data,
      UVM_FRONTDOOR
    );

    if (status != UVM_IS_OK) begin

      `uvm_error("LEGAL_ALIGNMENT_VSEQ", "CTRL readback failed")

    end

    else begin

      `uvm_info("LEGAL_ALIGNMENT_VSEQ",

                $sformatf("CTRL readback value = 0x%08h", data),
                UVM_LOW)
    end

    `uvm_info("LEGAL_ALIGNMENT_VSEQ", "Starting MD RX basic traffic", UVM_LOW)

    md_seq = md_rx_basic_seq::type_id::create("md_seq");
    md_seq.start(p_sequencer.md_rx_seqr);

    `uvm_info("LEGAL_ALIGNMENT_VSEQ", "MD RX basic traffic completed", UVM_LOW)

    drain_time_ns = 200;

    void'($value$plusargs("DRAIN_TIME_NS=%0d", drain_time_ns));

    `uvm_info("LEGAL_ALIGNMENT_VSEQ",
            
            $sformatf("Waiting %0d ns for TX drain", drain_time_ns),
            UVM_LOW)

#(drain_time_ns * 1ns);

`uvm_info("LEGAL_ALIGNMENT_VSEQ", "Reading STATUS register", UVM_LOW)

    p_sequencer.ral_model.STATUS.read(
      status,
      data,
      UVM_FRONTDOOR
    );

    if (status != UVM_IS_OK) begin

      `uvm_error("LEGAL_ALIGNMENT_VSEQ", "STATUS read failed")

    end

    else begin

      `uvm_info("LEGAL_ALIGNMENT_VSEQ",
      
                $sformatf("STATUS value after traffic = 0x%08h", data),
                UVM_LOW)
    end

    `uvm_info("LEGAL_ALIGNMENT_VSEQ", "Legal alignment virtual sequence completed", UVM_LOW)

  endtask

endclass