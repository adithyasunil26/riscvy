module imm_data_extractor(
  input [31:0] inst,
  output reg [63:0] imm_data
);

  always @(*) begin
    case (inst[6:5])
      2'b00: imm_data[11:0] = inst[31:20];
      2'b01: imm_data[11:0] = {inst[31:25], inst[11:7]};
      2'b11: imm_data[11:0] = {inst[31], inst[7], inst[30:25], inst[11:8]};
    endcase
    imm_data = {{52{imm_data[11]}}, {imm_data[11:0]}};
  end

endmodule
