class aligner_base_test extends uvm_test;

  `uvm_component_utils(aligner_base_test)

  aligner_env env;

  function new(string name = "aligner_base_test",

               uvm_component parent = null);

    super.new(name, parent);

  endfunction

  virtual function void build_phase(uvm_phase phase);

    super.build_phase(phase);

    env = aligner_env::type_id::create("env", this);

    `uvm_info("BASE_TEST", "aligner_base_test build_phase completed", UVM_LOW)

  endfunction

  virtual function void end_of_elaboration_phase(uvm_phase phase);

    super.end_of_elaboration_phase(phase);

    uvm_top.print_topology();

  endfunction

  virtual task run_phase(uvm_phase phase);

    phase.raise_objection(this);

    `uvm_info("BASE_TEST", "Base test running. No stimulus yet.", UVM_LOW)

    repeat (20) begin

      #10;

    end

    phase.drop_objection(this);
    
  endtask

endclass