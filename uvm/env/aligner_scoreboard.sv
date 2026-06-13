class aligner_scoreboard extends uvm_scoreboard;

  `uvm_component_utils(aligner_scoreboard)

  // Recibe TX esperado desde reference_model
  uvm_analysis_imp_expected #(md_item, aligner_scoreboard) expected_export;

  // Recibe TX real desde md_tx_monitor
  uvm_analysis_imp_actual #(md_item, aligner_scoreboard) actual_export;

  md_item expected_q[$];
  md_item actual_q[$];

  function new(string name = "aligner_scoreboard",

               uvm_component parent = null);

    super.new(name, parent);

  endfunction

  virtual function void build_phase(uvm_phase phase);

    super.build_phase(phase);

    expected_export = new("expected_export", this);
    actual_export   = new("actual_export", this);

    `uvm_info("SCB", "Scoreboard build_phase completed", UVM_LOW)

  endfunction

  virtual function void write_expected(md_item item);

    md_item item_c;

    $cast(item_c, item.clone());
    expected_q.push_back(item_c);

    `uvm_info("SCB",

              $sformatf("TX esperado recibido: data=0x%08h offset=%0d size=%0d err=%0b",
                        item.data, item.offset, item.size, item.err),

              UVM_LOW)

    compare_if_possible();

  endfunction

  virtual function void write_actual(md_item item);

    md_item item_c;

    $cast(item_c, item.clone());
    actual_q.push_back(item_c);

    `uvm_info("SCB",

              $sformatf("TX observado recibido: data=0x%08h offset=%0d size=%0d err=%0b",
                        item.data, item.offset, item.size, item.err),

              UVM_LOW)

    compare_if_possible();

  endfunction

  virtual function void compare_if_possible();

    md_item exp;
    md_item act;

    while ((expected_q.size() > 0) && (actual_q.size() > 0)) begin

      exp = expected_q.pop_front();
      act = actual_q.pop_front();

      if ((exp.data   !== act.data)   ||
          (exp.offset !== act.offset) ||
          (exp.size   !== act.size)   ||
          (exp.err    !== act.err)) begin

        `uvm_error("SCB_MISMATCH",

                   $sformatf("Mismatch TX. EXP data=0x%08h offset=%0d size=%0d err=%0b | ACT data=0x%08h offset=%0d size=%0d err=%0b",
                             exp.data, exp.offset, exp.size, exp.err,
                             act.data, act.offset, act.size, act.err))
      end
      else begin

        `uvm_info("SCB_MATCH",

                  $sformatf("Match TX: data=0x%08h offset=%0d size=%0d err=%0b",
                            act.data, act.offset, act.size, act.err),
                  UVM_LOW)

      end
    end
  endfunction

  virtual function void check_phase(uvm_phase phase);

    super.check_phase(phase);

    if (expected_q.size() != 0) begin

      `uvm_error("SCB_CHECK",
                 $sformatf("Quedaron %0d transacciones esperadas sin observar",
                           expected_q.size()))

    end

    if (actual_q.size() != 0) begin

      `uvm_error("SCB_CHECK",
                 $sformatf("Quedaron %0d transacciones observadas sin esperado",
                           actual_q.size()))
                           
    end
  endfunction

endclass