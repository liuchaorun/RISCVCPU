`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/06/22 10:31:25
// Design Name: 
// Module Name: TOP
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module TOP(

    );
    
    // global signal
    reg                 clk;
    reg                 rst;
    
    // IF input
    reg                 IF_start_in;
    reg     [31:0]      IF_PC_in;
    wire                EX_pc_sel_out;
    wire    [31:0]      EX_new_pc_out;
    wire                ID_data_conflict_out;
    wire                ID_flush_out;
    // IF output
    wire     [31:0]     IF_next_PC_out;
    wire     [31:0]     IF_instruction_out;
    wire     [31:0]     IF_next_ena_out;

    // IF
    IF if_unit(
        .clk(clk),
        .rst(rst),
        .start(IF_start_in),
        .data_conflict(ID_data_conflict_out),
        .PC(IF_PC_in),        // choose PCPlus4 or nextPC
        .PC_sel(EX_pc_sel_out),
        .PC_jmp(EX_new_pc_out),
        .flush(ID_flush_out),
        
        .next_PC(IF_next_PC_out),
        .instruction(IF_instruction_out),
        .next_ena(IF_next_ena_out)
    );
    
    // ID output
    wire    [31:0]      ID_rs1_val_out;
    wire    [63:0]      ID_rs1_float_val_out;
    wire    [31:0]      ID_PC_out;
    wire                ID_operand1_sel_out;
    wire    [31:0]      ID_rs2_val_out;
    wire    [63:0]      ID_rs2_float_val_out;
    wire    [31:0]      ID_imm_out;
    wire                ID_operand2_sel_out;
    wire    [4:0]       ID_rd_idx_out;
    wire    [5:0]       ID_op_type_out;
    wire    [3:0]       ID_alu_type_out;
    wire    [11:0]      ID_csr_idx_out;
    wire                ID_next_ena_out;
    
    wire                WB_wb_out;
    wire    [4:0]       WB_wb_idx_out;
    wire    [31:0]      WB_wb_val_out;
    wire                WB_wb_float_out;
    wire    [4:0]       WB_wb_float_idx_out;
    wire    [63:0]      WB_wb_float_val_out;
    wire    [2:0]       ID_float_rm;

    ID id_unit(
        .clk(clk),
        .rst(rst),
        .start(IF_next_ena_out),
        .next_PC(IF_next_PC_out),
        .IR(IF_instruction_out),
        .wb_idx(WB_wb_idx_out),
        .wb_val(WB_wb_val_out),
        .wb(WB_wb_out),
        .wb_float_idx(WB_wb_float_idx_out),
        .wb_float_val(WB_wb_float_val_out),
        .wb_float(WB_wb_float_out),
        .pc_sel(EX_pc_sel_out),

        .rs1_val(ID_rs1_val_out),
        .rs1_float_val(ID_rs1_float_val_out),
        .PC(ID_PC_out),
        .operand1_sel(ID_operand1_sel_out),
        .rs2_val(ID_rs2_val_out),
        .rs2_float_val(ID_rs2_float_val_out),
        .imm(ID_imm_out),
        .operand2_sel(ID_operand2_sel_out),
        .rd_idx(ID_rd_idx_out),
        .op_type(ID_op_type_out),
        .alu_type(ID_alu_type_out),
        .float_rm(ID_float_rm),
        .csr_idx(ID_csr_idx_out),
        .data_conflict(ID_data_conflict_out),
        .next_ena(ID_next_ena_out),
        .flush(ID_flush_out)
    );

    // EX output
    wire    [31:0]      EX_rs1_val_out;
    wire    [63:0]      EX_rs1_float_val_out;        
    wire    [31:0]      EX_PC_out;
    wire    [31:0]      EX_rs2_val_out;
    wire    [63:0]      EX_rs2_float_val_out;
    wire    [31:0]      EX_imm_out;
    wire    [4:0]       EX_rd_idx_out;
    wire    [5:0]       EX_op_type_out;
    wire    [11:0]      EX_csr_idx_out;
    wire    [31:0]      EX_ex_output_out;
    wire    [7:0]       EX_mask_out;
    wire                EX_next_ena_out;
    wire                EX_store_ena_out;
    wire    [63:0]      EX_ex_float_output;
    wire    [2:0]       EX_float_rm_out;
    wire    [2:0]       EX_float_rm_val;
    wire    [4:0]       EX_fflags_accured_exceptions;

    EX ex_unit(
        .clk(clk),
        .rst(rst),
        .start(~ID_data_conflict_out),
        .rs1_val(ID_rs1_val_out),
        .rs1_float_val(ID_rs1_float_val_out),
        .PC(ID_PC_out),
        .operand1_sel(ID_operand1_sel_out),
        .rs2_val(ID_rs2_val_out),
        .rs2_float_val(ID_rs2_float_val_out),
        .imm(ID_imm_out),
        .operand2_sel(ID_operand2_sel_out),
        .rd_idx(ID_rd_idx_out),
        .op_type(ID_op_type_out),
        .alu_type(ID_alu_type_out),
        .float_rm(ID_float_rm),
        .csr_idx(ID_csr_idx_out),
  
        .rs1_val_out(EX_rs1_val_out),
        .rs1_float_val_out(EX_rs1_float_val_out),        
        .PC_out(EX_PC_out),
        .rs2_val_out(EX_rs2_val_out),
        .rs2_float_val_out(EX_rs2_float_val_out),
        .imm_out(EX_imm_out),
        .rd_idx_out(EX_rd_idx_out),
        .op_type_out(EX_op_type_out),
        .csr_idx_out(EX_csr_idx_out),

        .ex_output(EX_ex_output_out),
        .ex_float_output(EX_ex_float_output),
        .float_rm_out(EX_float_rm_out),
        .float_rm_val(EX_float_rm_val),
        .fflags_accured_exceptions(EX_fflags_accured_exceptions),
        .pc_sel(EX_pc_sel_out),
        .new_pc(EX_new_pc_out),
        .mask(EX_mask_out),
        .next_ena(EX_next_ena_out),
        .store_ena(EX_store_ena_out)
    );

    // MEM output
    wire    [31:0]      MEM_rd_val_out;
    wire    [63:0]      MEM_rd_float_val_out;
    wire    [4:0]       MEM_rd_idx_out;
    wire    [5:0]       MEM_op_type_out;
    wire    [31:0]      MEM_rs1_val_out;
    wire    [31:0]      MEM_imm_out;
    wire    [11:0]      MEM_csr_idx_out;
    wire                MEM_next_ena_out;
    wire    [2:0]       MEM_float_rm_out;
    wire    [2:0]       MEM_float_rm_val_out;
    wire    [4:0]       MEM_fflags_accured_exceptions_out;

    // MEM
     MEM mem_unit(
        .clk(clk),
        .rst(rst),
        .start(EX_next_ena_out),
        .ex_output(EX_ex_output_out),
        .ex_float_output(EX_ex_float_output),
        .float_rm(EX_float_rm_out),
        .float_rm_val(EX_float_rm_val),
        .fflags_accured_exceptions(EX_fflags_accured_exceptions),
        .rd_idx(EX_rd_idx_out),
        .op_type(EX_op_type_out),
        .rs1_val(EX_rs1_val_out),
        .rs1_float_val(EX_rs1_float_val_out),
        .rs2_val(EX_rs2_val_out),
        .rs2_float_val(EX_rs2_float_val_out),
        .imm(EX_imm_out),
        .PC(EX_PC_out),
        .csr_idx(EX_csr_idx_out),
        .mask(EX_mask_out),
        .store_ena(EX_store_ena_out),

        .rd_val(MEM_rd_val_out),
        .rd_float_val(MEM_rd_float_val_out),
        .float_rm_out(MEM_float_rm_out),
        .float_rm_val_out(MEM_float_rm_val_out),
        .fflags_accured_exceptions_out(MEM_fflags_accured_exceptions_out),
        .rd_idx_out(MEM_rd_idx_out),
        .op_type_out(MEM_op_type_out),
        .rs1_val_out(MEM_rs1_val_out),
        .imm_out(MEM_imm_out),
        .csr_idx_out(MEM_csr_idx_out),
        .next_ena(MEM_next_ena_out)
    );
    
    // WB
    WB wb_unit(
        .clk(clk),
        .rst(rst),
        .start(MEM_next_ena_out),

        .rd_val(MEM_rd_val_out),
        .rd_float_val(MEM_rd_float_val_out),
        .rd_idx(MEM_rd_idx_out),
        .op_type(MEM_op_type_out),
        .rs1_val(MEM_rs1_val_out),
        .imm(MEM_imm_out),
        .csr_idx(MEM_csr_idx_out),
        .float_rm(MEM_float_rm_out),
        .float_rm_val(MEM_float_rm_val_out),
        .fflags_accured_exceptions(MEM_fflags_accured_exceptions_out),

        .wb(WB_wb_out),
        .wb_idx(WB_wb_idx_out),
        .wb_val(WB_wb_val_out),
        .wb_float(WB_wb_float_out),
        .wb_float_idx(WB_wb_float_idx_out),
        .wb_float_val(WB_wb_float_val_out)
    );

    
//    // ID input
//    wire     [4:0]   wbRd_wb_out;
//    wire     [31:0]  wbV_wb_out;
//    wire             wb_wb_out;
//    // ID output
//    wire    [31:0]  rs1_val_id_out;
//    wire    [31:0]  rs2_val_id_out;
//    wire    [31:0]  imm_id_out;
//    wire    [4:0]   rd_idx_id_out;
//    wire    [3:0]   op_type_id_out;
//    wire    [3:0]   alu_type_id_out;
//    wire    [3:0]   br_type_id_out;
//    wire            operand_type_id_out;
//    wire    [31:0]   newpc_id_out;
//    wire            pc_sel_id_out;
//    wire            rd_pc_id_out;
//    wire            rdpc_sel_id_out;
//    wire            csr_idx_id_out;
    
//    // ID
//    ID id_unit(
//        .clk(clk),
//        .rst(rst),
//        .start(id_ena),
//        .NPC(next_PC),
//        .IR(instruction),
//        .wbRd(wbRd_wb_out),
//        .wbV(wbV_wb_out),
//        .wb(wb_wb_out),
//        .br_flush(br_flush_ex_out),
//        .rs1_val(rs1_val_id_out),
//        .rs2_val(rs2_val_id_out),
//        .imm(imm_id_out),
//        .rd_idx(rd_idx_id_out),
//    // no op(1), load(5), store(3), write rd(1), csr(6)
//        .op_type(op_type_id_out),
//    // << >> + - ^ & | cmp(<) * / %
//        .alu_type(alu_type_id_out),
//        .br_type(br_type_id_out),
//        .operand_type(operand_type_id_out),
//        .npc_id(newpc_id_out),
//        .stall(stall_id_out),
//        .csr_idx(csr_idx_id_out),
//        .flush(flush)
//    );
    
//    // EX output
//    wire    [31:0]      rs1_val_ex_out;        // just forward
//    wire    [31:0]      rs2_val_ex_out;
//    wire    [31:0]      imm_ex_out;
//    wire    [4:0]       rd_idx_ex_out;
//    wire    [3:0]       op_type_ex_out;
//    wire    [3:0]       csr_idx_ex_out;
//    wire    [31:0]      ex_output_ex_out;
//    wire                mem_stall_ex_out;
//    wire                alu_w_rd_ex_out;
//    wire     [3:0]      mask_ex_out;
//    wire                store_ena_ex_out;
    
//    EX ex_unit(
//        .clk(clk),
//        .rst(rst),
//        .start(~stall_id_out),

//        .rs1_val(rs1_val_id_out),
//        .rs2_val(rs2_val_id_out),
//        .imm(imm_id_out),
//        .npc_ex(newpc_id_out),
//        .rd_idx(rd_idx_id_out),
//        .op_type(op_type_id_out),
//        .alu_type(alu_type_id_out),
//        .br_type(br_type_id_out),
//        .operand2_sel(operand_type_id_out),
//        .csr_idx(csr_idx_id_out),
  
//        .rs1_val_out(rs1_val_ex_out),        // just forward
//        .rs2_val_out(rs2_val_ex_out),
//        .imm_out(imm_ex_out),
//        .rd_idx_out(rd_idx_ex_out),
//        .op_type_out(op_type_ex_out),
//        .csr_idx_out(csr_idx_ex_out),

//        .ex_output(ex_output_ex_out),           // address or rd_val
//        .mem_stall(mem_stall_ex_out),
//        .alu_w_rd(alu_w_rd_ex_out),
//        .newpc(newpc_ex_out),
//        .pc_sel(pc_sel_ex_out),
//        .br_flush(br_flush_ex_out),
//        .mask(mask_ex_out),
//        .store_ena(store_ena_ex_out)
//    );
    
//    // MEM output
//    wire[31:0] rd_val_mem_out;
//    wire[4:0] rd_idx_out_mem_out;
//    wire[3:0] op_type_out_mem_out;
//    wire[31:0] rs1_val_out_mem_out;
//    wire[31:0] imm_out_mem_out;
//    wire[11:0] csr_idx_out_mem_out;
//    wire wb_ena_mem_out;
    
//    MEM mem_unit(
//        .clk(clk),
//        .rst(rst),
//        .start(mem_stall_ex_out),

//        .ex_output(ex_output_ex_out),
//        .rd_idx(rd_idx_ex_out),
//        .op_type(op_type_ex_out),
//        .rs1_val(rs1_val_ex_out),
//        .rs2_val(rs2_val_ex_out),
//        .imm(imm_ex_out),
//        .csr_idx(csr_idx_ex_out),
//        .alu_w_rd(alu_w_rd_ex_out),
//        .mask(mask_ex_out),
//        .store_ena(store_ena_ex_out),

//        .rd_val(rd_val_mem_out),
//        .rd_idx_out(rd_idx_out_mem_out),
//        .op_type_out(op_type_out_mem_out),
//        .rs1_val_out(rs1_val_out_mem_out),
//        .imm_out(imm_out_mem_out),
//        .csr_idx_out(csr_idx_out_mem_out),
//        .wb_ena(wb_ena_mem_out)
//        );
         
    
//    WB wb_unit(
//        .clk(clk),
//        .rst(rst),
//        .start(IF_start),
        
//        .rd_val(rd_val_mem_out),
//        .rd_idx(rd_idx_out_mem_out),
//        .op_type(op_type_out_mem_out),
//        .rs1_val(rs1_val_out_mem_out),
//        .imm(imm_out_mem_out),
//        .csr_idx(csr_idx_out_mem_out),
//        .wb_ena(wb_ena_mem_out),
//        .wb(wb_wb_out),
//        .wbRd(wbRd_wb_out),
//        .wbV(wbV_wb_out)
//        );

    
    initial begin
        // IF input
        clk = 1'b0;
        rst = 1'b1;
        IF_PC_in = 32'h0001008c;
//        IF_PC_in = 32'h00000000;
        IF_start_in = 1'b1;
    end
    
    always #50 rst = 1'b0;
    
    always #50 begin 
        clk = ~clk;
        IF_PC_in = IF_next_PC_out;
    end
    
endmodule
