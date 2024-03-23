module decode(
  input [31:0] inst,
  input clk,
  input reset,
  output [63:0] ReadData1,
  output [63:0] ReadData2
);

  // wire [63:0] ;

  inst_parser inst_parser1(
    .inst     (inst),
    .opcode   (opcode),
    .rs1      (rs1),
    .rs2      (rs2),
    .rd       (rd),
    .funct3   (funct3),
    .funct7   (funct7)
  );

  reg_file reg_file1(
    .clk       (clk),   
    .reset     (reset),     
    .rs1       (rs1),   
    .rs2       (rs2),   
    .rd        (rd),  
    .WriteData (WriteData),         
    .reg_write (reg_write),         
    .ReadData1 (ReadData1),         
    .ReadData2 (ReadData2),         
    .r8        (r8),  
    .r19       (r19),   
    .r20       (r20),   
    .r21       (r21),   
    .r22       (r22)   
  );

  imm_data_extractor data_extractor_1(
    .inst     (inst),
    .imm_data (imm_data)
  );

  control_unit cu1(
    .opcode   (opcode),  
    .stall    (stall), 
    .branch   (branch),  
    .memread  (memread),   
    .memtoreg (memtoreg),    
    .memwrite (memwrite),    
    .aluSrc   (aluSrc),  
    .regwrite (regwrite),    
    .Aluop    (Aluop) 
  );

endmodule
