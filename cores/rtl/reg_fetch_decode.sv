module reg_fetch_decode(
  input clk,
  input reset,
  input flush,
  input write,
  input  [31:0] inst_in,
  input  [63:0] a_in,
  output reg [31:0] inst_out,
  output reg [63:0] a_out
);

  always @(posedge clk) begin
    if (reset == 1'b1 || flush == 1'b1) begin
      inst_out = 32'b0;
      a_out    = 64'b0;
    end
    else if (write == 1'b0) begin
      inst_out = inst_in;
      a_out    = a_in;
    end
  end

endmodule
