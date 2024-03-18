module alu_control (
  input [1:0] aluop,
  input [3:0] funct,
  output reg [3:0] op
);

  always @ (*) begin
    if (aluop==2'b00)
      op = 4'b0010;
    else if (aluop==2'b01)
      op = 4'b0110;
    else if (aluop==2'b10) begin
      if (funct == 4'b0000)
        op = 4'b0010;
      else if (funct == 4'b0110)
        op = 4'b0001;
      else if (funct == 4'b0111)
        op = 4'b0000;
      else if (funct == 4'b1000)
        op = 4'b0110;
    end
  end

endmodule
