interface md_if #(

  parameter int DATA_WIDTH = 32

)(

  input logic clk,
  input logic reset_n

);

  localparam int DATA_BYTES   = DATA_WIDTH / 8;
  localparam int OFFSET_WIDTH = (DATA_BYTES <= 1) ? 1 : $clog2(DATA_BYTES);
  localparam int SIZE_WIDTH   = $clog2(DATA_BYTES) + 1;

  logic                    valid;
  logic                    ready;
  logic                    err;
  logic [DATA_WIDTH-1:0]    data;
  logic [OFFSET_WIDTH-1:0]  offset;
  logic [SIZE_WIDTH-1:0]    size;

  // El encargado de envíar data, offset, size, valid
  modport source_mp (

    input  clk,
    input  reset_n,
    input  ready,
    input  err,
    output valid,
    output data,
    output offset,
    output size

  );

  // El engargado de recibir data y responde ready/err
  modport sink_mp (

    input  clk,
    input  reset_n,
    input  valid,
    input  data,
    input  offset,
    input  size,
    output ready,
    output err

  );

  // Monitor: observa todo
  modport mon_mp (

    input clk,
    input reset_n,
    input valid,
    input ready,
    input err,
    input data,
    input offset,
    input size
    
  );

endinterface