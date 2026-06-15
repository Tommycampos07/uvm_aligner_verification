class aligner_reference_model extends uvm_component;

  `uvm_component_utils(aligner_reference_model)

  uvm_analysis_imp_rx #(md_item, aligner_reference_model) rx_export;

  uvm_analysis_port #(md_item) expected_ap;

  byte unsigned byte_q[$];

  int unsigned cfg_tx_size;
  int unsigned cfg_tx_offset;

  function new(string name = "aligner_reference_model",

               uvm_component parent = null);

    super.new(name, parent);

    cfg_tx_size   = 1;
    cfg_tx_offset = 0;

  endfunction

  virtual function void build_phase(uvm_phase phase);

    super.build_phase(phase);

    rx_export   = new("rx_export", this);
    expected_ap = new("expected_ap", this);

    `uvm_info("REF_MODEL", "Reference model build_phase completed", UVM_LOW)

  endfunction

  virtual function void configure_output(int unsigned size,

                                         int unsigned offset);

    if ((size != 1) && (size != 2) && (size != 4)) begin
      `uvm_error("REF_MODEL",

                 $sformatf("Invalid TX size configuration: %0d", size))

      return;

    end

    if ((offset + size) > 4) begin

      `uvm_error("REF_MODEL",

                 $sformatf("Invalid TX offset/size configuration: offset=%0d size=%0d",
                           offset, size))

      return;

    end

    cfg_tx_size   = size;
    cfg_tx_offset = offset;

    `uvm_info("REF_MODEL",

              $sformatf("Reference model configured: tx_size=%0d tx_offset=%0d",
                        cfg_tx_size, cfg_tx_offset),
              UVM_LOW)

  endfunction

  virtual function void write_rx(md_item item);

    int unsigned i;
    byte unsigned b;

    `uvm_info("REF_MODEL",

              $sformatf("RX received by reference model: data=0x%08h offset=%0d size=%0d err=%0b",
                        item.data, item.offset, item.size, item.err),
              UVM_LOW)

    if (item.err) begin

      `uvm_warning("REF_MODEL", "RX item has err=1. Skipping expected generation.")

      return;

    end

    if ((item.size != 1) && (item.size != 2) && (item.size != 4)) begin

      `uvm_error("REF_MODEL",

                 $sformatf("Invalid RX size observed: %0d", item.size))

      return;
    end

    if ((item.offset + item.size) > 4) begin

      `uvm_error("REF_MODEL",

                 $sformatf("Invalid RX offset/size observed: offset=%0d size=%0d",
                           item.offset, item.size))

      return;

    end

    // Extract valid bytes from the RX word.
    // Byte order is little-endian:
    // byte 0 = data[7:0], byte 1 = data[15:8], etc.
    for (i = 0; i < item.size; i++) begin

      b = get_byte(item.data, item.offset + i);
      byte_q.push_back(b);

      `uvm_info("REF_MODEL",

                $sformatf("Queued byte 0x%02h from RX offset %0d",
                          b, item.offset + i),
                UVM_LOW)
    end

    emit_expected_tx();

  endfunction

  virtual function void emit_expected_tx();

    md_item exp;
    int unsigned i;
    byte unsigned b;

    if ((cfg_tx_size != 1) && (cfg_tx_size != 2) && (cfg_tx_size != 4)) begin

      `uvm_error("REF_MODEL",

                 $sformatf("Invalid configured TX size: %0d", cfg_tx_size))

      return;

    end

    if ((cfg_tx_offset + cfg_tx_size) > 4) begin

      `uvm_error("REF_MODEL",

                 $sformatf("Invalid configured TX offset/size: offset=%0d size=%0d",
                           cfg_tx_offset, cfg_tx_size))
                           
      return;

    end

    while (byte_q.size() >= cfg_tx_size) begin

      exp = md_item::type_id::create("exp");

      exp.data   = '0;
      exp.offset = cfg_tx_offset[1:0];
      exp.size   = cfg_tx_size[2:0];
      exp.err    = 1'b0;

      for (i = 0; i < cfg_tx_size; i++) begin

        b = byte_q.pop_front();
        exp.data = set_byte(exp.data, cfg_tx_offset + i, b);

      end

      expected_ap.write(exp);

      `uvm_info("REF_MODEL",

                $sformatf("Expected TX generated: data=0x%08h offset=%0d size=%0d err=%0b",
                          exp.data, exp.offset, exp.size, exp.err),
                UVM_LOW)

    end

  endfunction

  virtual function byte unsigned get_byte(bit [31:0] word,

                                          int unsigned byte_index);

    case (byte_index)

      0: return word[7:0];
      1: return word[15:8];
      2: return word[23:16];
      3: return word[31:24];

      default: begin

        `uvm_error("REF_MODEL",

                   $sformatf("Invalid byte index in get_byte: %0d", byte_index))
        return 8'h00;

      end

    endcase

  endfunction

  virtual function bit [31:0] set_byte(bit [31:0] word,

                                       int unsigned byte_index,
                                       byte unsigned value);

    case (byte_index)

      0: word[7:0]   = value;
      1: word[15:8]  = value;
      2: word[23:16] = value;
      3: word[31:24] = value;

      default: begin

        `uvm_error("REF_MODEL",

                   $sformatf("Invalid byte index in set_byte: %0d", byte_index))

      end
    endcase

    return word;

  endfunction

  virtual function void check_phase(uvm_phase phase);
    super.check_phase(phase);

    if (byte_q.size() != 0) begin

      `uvm_warning("REF_MODEL",

                   $sformatf("Reference model ended with %0d pending byte(s)",
                             byte_q.size()))
    end
  endfunction

endclass