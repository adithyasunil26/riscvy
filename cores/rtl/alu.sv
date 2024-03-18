module alu #(
  parameter WIDTH = 64
)(
  input [WIDTH-1:0] a,
  input [WIDTH-1:0] b,
  input [3:0] op,
  output reg [WIDTH-1:0] out,
  output reg zero
);

  always @(*) begin
    case (op)
      4'b0000: out = a & b;
      4'b0001: out = a | b;
      4'b0010: out = a + b;
      4'b0110: out = a - b;
      4'b1100: out = ~(a | b);
    endcase
    if (out == 0)
      zero = 1;
    else
      zero = 0;
  end

endmodule
