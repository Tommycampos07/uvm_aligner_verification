class md_rx_basic_seq extends uvm_sequence #(md_item);

  `uvm_object_utils(md_rx_basic_seq)

  function new(string name = "md_rx_basic_seq");

    super.new(name);

  endfunction

  virtual task body();

    `uvm_info("MD_RX_BASIC_SEQ", "Starting basic MD RX sequence", UVM_LOW)

    // Legal transfers for a 32-bit MD bus.
    // These are not yet randomized. They are deterministic smoke traffic.

    send_md_item(32'hAABB_CCDD, 2'd0, 3'd4);
    send_md_item(32'h1122_3344, 2'd0, 3'd2);
    send_md_item(32'h5566_7788, 2'd2, 3'd2);
    send_md_item(32'hDEAD_BEEF, 2'd0, 3'd1);
    send_md_item(32'hCAFE_BABE, 2'd1, 3'd1);
    send_md_item(32'h1234_5678, 2'd2, 3'd1);
    send_md_item(32'h8765_4321, 2'd3, 3'd1);

    `uvm_info("MD_RX_BASIC_SEQ", "Basic MD RX sequence completed", UVM_LOW)

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