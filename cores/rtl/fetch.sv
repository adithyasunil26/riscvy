module fetch(
  input [63:0] PC_ex,
  input sel,
  input clk,
  input reset,
  input stall,
  output [31:0] inst,
  output [63:0] PC_out
);

  wire [63:0] PC_f;
  wire [63:0] PC_in;

  mux2_1 mux1(
    .a  (PC_f),
    .b  (PC_ex),
    .sel(sel),
    .out(PC_in)
  );

  adder adder1(
    .a  (PC_out),
    .b  (64'd4),
    .sum(PC_f)
  );

  program_counter pc(
    .PC_in (PC_in),
    .clk   (clk),
    .reset (reset),
    .stall (stall),
    .PC_out(PC_out)
  );

  inst_memory instructions(
    .inst_address(PC_out),
    .instruction(inst)
  );

endmodule
