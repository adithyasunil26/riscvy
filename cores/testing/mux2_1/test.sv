module test#(
  parameter WIDTH = 64,
  parameter CLK_PERIOD = 20
)();

  reg [WIDTH-1:0] a,b;
  reg sel;
  wire [WIDTH-1:0] out;
  reg clk;

  mux2_1 #(64) mux(
    .a(a),
    .b(b),
    .sel(sel),
    .out(out)
  );

  always #(CLK_PERIOD/2.0)
    clk = ~clk;
  
  always @ (posedge clk) begin
    a = a + 1'b1;
    b = b + 1'b1;
  end

  always @ (negedge clk) begin
    $display("clk=%d sel=%d a=%d b=%d out=%d", clk, sel, a, b, out);
  end
  
  initial begin
    clk = 1'b0;
    a = 1'b0;
    b = 1'b0;
    sel = 1'b0;
  end

endmodule
