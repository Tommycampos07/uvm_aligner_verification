class ral_basic_vseq extends uvm_sequence;

  `uvm_object_utils(ral_basic_vseq)
  `uvm_declare_p_sequencer(aligner_virtualseq)

  function new(string name = "ral_basic_vseq");

    super.new(name);

  endfunction

  virtual task body();

    uvm_status_e status;
    uvm_reg_data_t data;

    `uvm_info("RAL_BASIC_VSEQ", "Starting basic RAL sequence", UVM_LOW)

    if (p_sequencer.ral_model == null) begin

      `uvm_fatal("RAL_BASIC_VSEQ", "RAL model handle is null")

    end

    // WRITE CTRL
    `uvm_info("RAL_BASIC_VSEQ", "Writing CTRL register", UVM_LOW)

    p_sequencer.ral_model.CTRL.write(

      status,
      32'h0000_0001,
      UVM_FRONTDOOR

    );

    if (status != UVM_IS_OK) begin

      `uvm_error("RAL_BASIC_VSEQ", "CTRL write failed")

    end

    // READ CTRL
    `uvm_info("RAL_BASIC_VSEQ", "Reading CTRL register", UVM_LOW)

    p_sequencer.ral_model.CTRL.read(

      status,
      data,
      UVM_FRONTDOOR

    );

    if (status != UVM_IS_OK) begin

      `uvm_error("RAL_BASIC_VSEQ", "CTRL read failed")

    end
    else begin

      `uvm_info("RAL_BASIC_VSEQ",

                $sformatf("CTRL read value = 0x%08h", data),

                UVM_LOW)

    end

    // READ STATUS
    `uvm_info("RAL_BASIC_VSEQ", "Reading STATUS register", UVM_LOW)

    p_sequencer.ral_model.STATUS.read(

      status,
      data,
      UVM_FRONTDOOR

    );

    if (status != UVM_IS_OK) begin

      `uvm_error("RAL_BASIC_VSEQ", "STATUS read failed")

    end
    else begin

      `uvm_info("RAL_BASIC_VSEQ",

                $sformatf("STATUS read value = 0x%08h", data),
                
                UVM_LOW)
    end

    `uvm_info("RAL_BASIC_VSEQ", "Basic RAL sequence completed", UVM_LOW)

  endtask

endclass