module mux2_1#(
  parameter WIDTH = 64
)(
  input [WIDTH-1:0] a,
  input [WIDTH-1:0] b,
  input sel,
  output reg [WIDTH-1:0] out
);

  always @ (a or b or sel) begin
    if (sel==1'b0)
      out = a;
    else
      out = b;
  end

endmodule
