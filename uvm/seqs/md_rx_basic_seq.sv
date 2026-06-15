class md_rx_basic_seq extends uvm_sequence #(md_item);

  `uvm_object_utils(md_rx_basic_seq)

  int unsigned num_items;
  bit fixed_traffic;

  function new(string name = "md_rx_basic_seq");
  
    super.new(name);

    num_items     = 7;
    fixed_traffic = 1'b1;

  endfunction

  virtual task body();

    `uvm_info("MD_RX_BASIC_SEQ", "Starting basic MD RX sequence", UVM_LOW)

    void'($value$plusargs("NUM_ITEMS=%0d", num_items));
    void'($value$plusargs("FIXED_TRAFFIC=%0d", fixed_traffic));

    `uvm_info("MD_RX_BASIC_SEQ",

              $sformatf("Sequence configuration: NUM_ITEMS=%0d FIXED_TRAFFIC=%0b",
                        num_items, fixed_traffic),
              UVM_LOW)

    if (fixed_traffic) begin

      send_fixed_traffic();

    end
    else begin

      send_random_traffic(num_items);

    end

    `uvm_info("MD_RX_BASIC_SEQ", "Basic MD RX sequence completed", UVM_LOW)

  endtask

  virtual task send_fixed_traffic();

    send_md_item(32'hAABB_CCDD, 2'd0, 3'd4);
    send_md_item(32'h1122_3344, 2'd0, 3'd2);
    send_md_item(32'h5566_7788, 2'd2, 3'd2);
    send_md_item(32'hDEAD_BEEF, 2'd0, 3'd1);
    send_md_item(32'hCAFE_BABE, 2'd1, 3'd1);
    send_md_item(32'h1234_5678, 2'd2, 3'd1);
    send_md_item(32'h8765_4321, 2'd3, 3'd1);

  endtask

  virtual task send_random_traffic(int unsigned n);

    md_item item;

    for (int unsigned i = 0; i < n; i++) begin

      item = md_item::type_id::create($sformatf("random_md_item_%0d", i));

      start_item(item);

      if (!item.randomize() with {

        err == 0;

        size inside {1, 2, 4};

        if (size == 1) {
          offset inside {0, 1, 2, 3};
        }

        if (size == 2) {
          offset inside {0, 2};
        }

        if (size == 4) {
          offset == 0;
        }
      }) begin

        `uvm_fatal("MD_RX_BASIC_SEQ", "Failed to randomize MD RX item")

      end

      finish_item(item);

      `uvm_info("MD_RX_BASIC_SEQ",

                $sformatf("Sent random MD RX item: data=0x%08h offset=%0d size=%0d",
                          item.data, item.offset, item.size),
                UVM_LOW)

    end

  endtask

  virtual task send_md_item(bit [31:0] data,
                            bit [1:0]  offset,
                            bit [2:0]  size);

    md_item item;

    item = md_item::type_id::create("item");

    start_item(item);

    item.data   = data;
    item.offset = offset;
    item.size   = size;
    item.err    = 1'b0;

    finish_item(item);

    `uvm_info("MD_RX_BASIC_SEQ",

              $sformatf("Sent MD RX item: data=0x%08h offset=%0d size=%0d",
                        data, offset, size),
              UVM_LOW)

  endtask

endclass