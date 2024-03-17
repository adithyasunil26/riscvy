module program_counter(
  input [63:0] PC_in,
  input clk,
  input reset,
  input stall,
  output reg [63:0] PC_out
);

  always @ (posedge clk or posedge reset)
    if (reset == 1'b1)
      PC_out = 64'd0;
    else if (stall == 1'b0) 
      PC_out = PC_in;


endmodule
