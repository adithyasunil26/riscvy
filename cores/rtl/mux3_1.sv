module mux3_1#(
  parameter WIDTH = 64
)(
  input [WIDTH-1:0] a,
  input [WIDTH-1:0] b,
  input [WIDTH-1:0] c,
  input [1:0] sel,
  output reg [WIDTH-1:0] out
);

  always @(*) begin
    case(sel)
      2'b00: out = a;
      2'b01: out = b;
      2'b10: out = c;
    endcase
  end

endmodule
