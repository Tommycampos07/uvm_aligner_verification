class aligner_coverage extends uvm_subscriber #(md_item);

  `uvm_component_utils(aligner_coverage)

  md_item cov_item;

  covergroup md_cg;

    option.per_instance = 1;

    cp_size: coverpoint cov_item.size {
      bins byte_access     = {1};
      bins halfword_access = {2};
      bins word_access     = {4};
      illegal_bins zero_size = {0};
    }

    cp_offset: coverpoint cov_item.offset {
      bins offset_0 = {0};
      bins offset_1 = {1};
      bins offset_2 = {2};
      bins offset_3 = {3};
    }

    cp_err: coverpoint cov_item.err {
      bins no_error = {0};
      bins error    = {1};
    }

    cp_data_lsb: coverpoint cov_item.data[7:0] {
      bins low_values  = {[8'h00:8'h3F]};
      bins mid_values  = {[8'h40:8'hBF]};
      bins high_values = {[8'hC0:8'hFF]};
    }

    cross_size_offset: cross cp_size, cp_offset;

  endgroup

  function new(string name = "aligner_coverage",
  
               uvm_component parent = null);

    super.new(name, parent);

    md_cg = new();

  endfunction

  virtual function void write(md_item t);

    cov_item = t;
    md_cg.sample();

    `uvm_info("COV",

              $sformatf("Sampled MD coverage: data=0x%08h offset=%0d size=%0d err=%0b coverage=%0.2f%%",
                        t.data,
                        t.offset,
                        t.size,
                        t.err,
                        md_cg.get_inst_coverage()),
              UVM_LOW)

  endfunction

  virtual function void report_phase(uvm_phase phase);

    super.report_phase(phase);

    `uvm_info("COV",

              $sformatf("Final MD coverage = %0.2f%%",
                        md_cg.get_inst_coverage()),
              UVM_LOW)

  endfunction

endclass