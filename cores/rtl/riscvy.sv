module riscvy(
  input clk,
  input reset,
  input wire[63:0] element1,
  input wire[63:0] element2,
  input wire[63:0] element3,
  input wire[63:0] element4,
  input wire[63:0] element5,
  input wire[63:0] element6,
  input wire[63:0] element7,
  input wire[63:0] element8,
  input stall,
  input flush
);
  
  // Fetch

  fetch fetch_module(
    .PC_ex    (PC_ex),//exmem_out_adder
    .sel      (BRANCH & branch_final),
    .clk      (clk),
    .reset    (reset),
    .stall    (stall),
    .inst     (inst),
    .PC_out   (PC_out)
  );

  reg_fetch_decode rfd(
    .clk      (clk),
    .reset    (reset),
    .flush    (flush),
    .write    (write),
    .inst_in  (inst),
    .a_in     (PC_out),
    .inst_out (inst_rfd_out),
    .a_out    (random)
  );

  // Decode

  decode decode_module(
    .inst,      (inst_rfd_out),
    .clk,       (clk),
    .reset,     (reset),
    .ReadData1, (readdata1),
    .ReadData2, (readdata2),
    .rs1,       (rs1),
    .rs2,       (rs2),
    .rd,        (rd),
    .WriteData, (write_data),
    .RD,        (RD),
    .reg_write, (memwb_regwrite),
    .funct3,    (funct3),
    .funct7     (funct7),
    .imm_data   (imm_data),
    .branch     (branch),
    .memread    (memread),
    .memtoreg   (memtoreg),
    .memwrite   (memwrite),
    .aluSrc     (ALUsrc),
    .regwrite   (regwrite),
    .Aluop      (ALUop)
  );

  reg_decode_execute rde(
    .clk(clk),
    .flush(flush),
    .reset(reset),
    .funct4_in({inst_rfd_out[30],inst_rfd_out[14:12]}),
    .A_in(random),
    .readdata1_in(readdata1),
    .readdata2_in(readdata2),
    .imm_data_in(imm_data),
    .rs1_in(rs1),.rs2_in(rs2),.rd_in(rd),
    .branch_in(branch),.memread_in(memread),.memtoreg_in(memtoreg),
    .memwrite_in(memwrite),.aluSrc_in(ALUsrc),.regwrite_in(regwrite),.Aluop_in(ALUop),
    .a(a1),.rs1(RS1),.rs2(RS2),.rd(RD),.imm_data(d),.readdata1(readdata1_exe),.readdata2(readdata2_exe),
    .funct4_out(funct4_out),.Branch(Branch),.Memread(Memread),.Memtoreg(Memtoreg),
    .Memwrite(Memwrite),.Regwrite(Regwrite),.Alusrc(Alusrc),.aluop(aluop)
  );

  // Execute

  execute execute_module(
    .a           (a1),
    .d           (d),
    .readdata1   (readdata1_exe),
    .readdata2   (readdata2_exe),
    .Alusrc      (Alusrc),
    .aluop       (aluop),
    .funct4_out  (funct4_out),
    .forwardA    (forwardA),
    .forwardB    (forwardB),
    .adderout    (adderout),
    .AluResult   (AluResult),
  );

  reg_execute_memory rem(
    .clk(clk),.reset(reset),.Adder_out(adderout),.Result_in_alu(AluResult),.Zero_in(zero),.flush(flush),
    .writedata_in(m3_1_out2),.Rd_in(RD), .addermuxselect_in(addermuxselect),
    .branch_in(Branch),.memread_in(Memread),.memtoreg_in(Memtoreg),.memwrite_in(Memwrite),.regwrite_in(Regwrite),
    .Adderout( exmem_out_adder),.zero(exmem_out_zero),.result_out_alu(exmem_out_result),.writedata_out(write_Data),
    .rd(exmemrd),.Branch(BRANCH),.Memread(MEMREAD),.Memtoreg(MEMTOREG),.Memwrite(MEMEWRITE),.Regwrite(REGWRITE), .addermuxselect(branch_final)
  );

  // Memory

  data_memory datamem
  (
    .write_data(write_Data),
    .address(exmem_out_result),
    .memorywrite(MEMEWRITE),
    .clk(clk),
    .memoryread(MEMREAD),
    .read_data(readdata),
    .element1(element1),
    .element2(element2),
    .element3(element3),
    .element4(element4),
    .element5(element5),
    .element6(element6),
    .element7(element7),
    .element8(element8)
  );

  reg_memory_writeback rmw(
    .clk(clk),.reset(reset),.read_data_in(readdata),
    .result_alu_in(exmem_out_result),.Rd_in(exmemrd),.memtoreg_in(MEMTOREG),.regwrite_in(REGWRITE),
    .readdata(muxin1),.result_alu_out(muxin2),.rd(RD),.Memtoreg(memwb_memtoreg),.Regwrite(memwb_regwrite)
  );

  // Writeback and hazard modules

  pipeline_flush p_flush(
    .branch(branch_final & BRANCH),
    .flush(flush)
  );

  hazard_detection_unit hu(
    .Memread(Memread),
    .inst(inst_rfd_out),
    .Rd(RD),
    .stall(stall)
  );

  mux2_1 mux3(
    .A(muxin2),.B(muxin1),.SEL(memwb_memtoreg),.Y(write_data)
  );

  forwarding_unit f1(
    .RS_1(RS1),.RS_2(RS2),.rdMem(exmemrd),
    .rdWb(RD),.regWrite_Wb(memwb_regwrite),
    .regWrite_Mem(REGWRITE),
    .Forward_A(forwardA),.Forward_B(forwardB)
  );

  branching_unit branc(
    .funct3(funct4_out[2:0]),.readData1(M1),.b(alu_64_b),.addermuxselect(addermuxselect)
  );

endmodule
