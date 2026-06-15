class aligner_coverage extends uvm_subscriber #(md_item);

  `uvm_component_utils(aligner_coverage)

  // Última transacción recibida
  md_item tr;

  covergroup md_cg;

    option.per_instance = 1;

    cp_size: coverpoint tr.size {
      bins size_1 = {1};
      bins size_2 = {2};
      bins size_4 = {4};
      illegal_bins illegal_size_0 = {0};
      illegal_bins illegal_other  = {[5:7]};
    }

    cp_offset: coverpoint tr.offset {
      bins offset_0 = {0};
      bins offset_1 = {1};
      bins offset_2 = {2};
      bins offset_3 = {3};
    }

    cp_size_offset: cross cp_size, cp_offset {
      bins legal_size1_offset0 = binsof(cp_size.size_1) && binsof(cp_offset.offset_0);
      bins legal_size1_offset1 = binsof(cp_size.size_1) && binsof(cp_offset.offset_1);
      bins legal_size1_offset2 = binsof(cp_size.size_1) && binsof(cp_offset.offset_2);
      bins legal_size1_offset3 = binsof(cp_size.size_1) && binsof(cp_offset.offset_3);

      bins legal_size2_offset0 = binsof(cp_size.size_2) && binsof(cp_offset.offset_0);
      bins legal_size2_offset2 = binsof(cp_size.size_2) && binsof(cp_offset.offset_2);

      bins legal_size4_offset0 = binsof(cp_size.size_4) && binsof(cp_offset.offset_0);

      illegal_bins illegal_size2_offset1 = binsof(cp_size.size_2) && binsof(cp_offset.offset_1);
      illegal_bins illegal_size2_offset3 = binsof(cp_size.size_2) && binsof(cp_offset.offset_3);

      illegal_bins illegal_size4_offset1 = binsof(cp_size.size_4) && binsof(cp_offset.offset_1);
      illegal_bins illegal_size4_offset2 = binsof(cp_size.size_4) && binsof(cp_offset.offset_2);
      illegal_bins illegal_size4_offset3 = binsof(cp_size.size_4) && binsof(cp_offset.offset_3);
    }

  endgroup

  function new(string name = "aligner_coverage",

               uvm_component parent = null);

    super.new(name, parent);

    md_cg = new();

  endfunction

  virtual function void write(md_item t);

    if (!$cast(tr, t.clone())) begin

      `uvm_error("COV", "Failed to clone md_item")

      return;

    end

    md_cg.sample();

    `uvm_info("COV",
    
              $sformatf("Sampled MD coverage: data=0x%08h offset=%0d size=%0d err=%0b",
                        tr.data, tr.offset, tr.size, tr.err),
              UVM_LOW)

  endfunction

endclass