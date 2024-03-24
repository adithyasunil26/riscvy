module execute(
  input [63:0] a,
  input [63:0] d,
  input [63:0] readdata1,
  input [63:0] readdata2,
  input Alusrc,
  input [1:0] aluop,
  input [3:0] funct4_out,
  input [1:0] forwardA,
  input [1:0] forwardB,
  output [63:0] adderout,
  output [63:0] AluResult
);

  adder adder2(
    .a(a),
    .b(d<<1),
    .sum(adderout)
  );

  mux3_1 m3_11(
    .a(readdata1),.b(write_data),.c(exmem_out_result),.sel(forwardA),.out(m3_1_out1)
  );

  mux3_1 m3_12(
    .a(readdata2),.b(write_data),.c(exmem_out_result),.sel(forwardB),.out(m3_1_out2)
  );

  mux2_1 mux2_11(
    .a(m3_1_out2),.b(d),.sel(Alusrc),.out(alu_64_b)
  );

  alu alu1(
    .a(m3_1_out1),
    .b(alu_64_b),
    .op(operation),
    .out(AluResult),
    .zero(zero)
  );

  alu_control ac
  (
    .aluop(aluop),
    .funct(funct4_out),
    .op(operation)
  );

endmodule
