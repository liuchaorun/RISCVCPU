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
    
    reg                 clk;
    reg                 rst;
    
    // IF input
    reg                IF_start;
    reg                 PC_j;
    reg     [31:0]      PC_branch;
    // IF output
    wire     [31:0]      PC_plus4;
    wire     [31:0]      next_PC;
    wire    [31:0]      instruction;
    wire                id_ena;
    wire            stall_id_out;
    wire            flush;
    
    wire     [31:0]           newpc_ex_out;
    wire                pc_sel_ex_out;
    wire                br_flush_ex_out;
    
    // IF
    IF if_unit(
        .clk(clk),
        .rst(rst),
        .start(IF_start),
        .stall(stall_id_out),
        .PC_jmp(pc_sel_ex_out),        // choose PCPlus4 or nextPC
        .PC_branch(newpc_ex_out),
        .PC_plus4(PC_plus4),
        .flush(flush),
        .br_flush(br_flush_ex_out),
        .next_PC(next_PC),
        .instruction(instruction),
        .id_ena(id_ena)
    );
    
    // ID input
    wire     [4:0]   wbRd_wb_out;
    wire     [31:0]  wbV_wb_out;
    wire             wb_wb_out;
    // ID output
    wire    [31:0]  rs1_val_id_out;
    wire    [31:0]  rs2_val_id_out;
    wire    [31:0]  imm_id_out;
    wire    [4:0]   rd_idx_id_out;
    wire    [3:0]   op_type_id_out;
    wire    [3:0]   alu_type_id_out;
    wire    [3:0]   br_type_id_out;
    wire            operand_type_id_out;
    wire    [31:0]   newpc_id_out;
    wire            pc_sel_id_out;
    wire            rd_pc_id_out;
    wire            rdpc_sel_id_out;
    wire            csr_idx_id_out;
    
    // ID
    ID id_unit(
        .clk(clk),
        .rst(rst),
        .start(id_ena),
        .NPC(next_PC),
        .IR(instruction),
        .wbRd(wbRd_wb_out),
        .wbV(wbV_wb_out),
        .wb(wb_wb_out),
        .br_flush(br_flush_ex_out),
        .rs1_val(rs1_val_id_out),
        .rs2_val(rs2_val_id_out),
        .imm(imm_id_out),
        .rd_idx(rd_idx_id_out),
    // no op(1), load(5), store(3), write rd(1), csr(6)
        .op_type(op_type_id_out),
    // << >> + - ^ & | cmp(<) * / %
        .alu_type(alu_type_id_out),
        .br_type(br_type_id_out),
        .operand_type(operand_type_id_out),
        .npc_id(newpc_id_out),
        .stall(stall_id_out),
        .csr_idx(csr_idx_id_out),
        .flush(flush)
    );
    
    // EX output
    wire    [31:0]      rs1_val_ex_out;        // just forward
    wire    [31:0]      rs2_val_ex_out;
    wire    [31:0]      imm_ex_out;
    wire    [4:0]       rd_idx_ex_out;
    wire    [3:0]       op_type_ex_out;
    wire    [3:0]       csr_idx_ex_out;
    wire    [31:0]      ex_output_ex_out;
    wire                mem_stall_ex_out;
    wire                alu_w_rd_ex_out;
    wire     [3:0]      mask_ex_out;
    wire                store_ena_ex_out;
    
    EX ex_unit(
        .clk(clk),
        .rst(rst),
        .start(~stall_id_out),

        .rs1_val(rs1_val_id_out),
        .rs2_val(rs2_val_id_out),
        .imm(imm_id_out),
        .npc_ex(newpc_id_out),
        .rd_idx(rd_idx_id_out),
        .op_type(op_type_id_out),
        .alu_type(alu_type_id_out),
        .br_type(br_type_id_out),
        .operand2_sel(operand_type_id_out),
        .csr_idx(csr_idx_id_out),
  
        .rs1_val_out(rs1_val_ex_out),        // just forward
        .rs2_val_out(rs2_val_ex_out),
        .imm_out(imm_ex_out),
        .rd_idx_out(rd_idx_ex_out),
        .op_type_out(op_type_ex_out),
        .csr_idx_out(csr_idx_ex_out),

        .ex_output(ex_output_ex_out),           // address or rd_val
        .mem_stall(mem_stall_ex_out),
        .alu_w_rd(alu_w_rd_ex_out),
        .newpc(newpc_ex_out),
        .pc_sel(pc_sel_ex_out),
        .br_flush(br_flush_ex_out),
        .mask(mask_ex_out),
        .store_ena(store_ena_ex_out)
    );
    
    // MEM output
    wire[31:0] rd_val_mem_out;
    wire[4:0] rd_idx_out_mem_out;
    wire[3:0] op_type_out_mem_out;
    wire[31:0] rs1_val_out_mem_out;
    wire[31:0] imm_out_mem_out;
    wire[11:0] csr_idx_out_mem_out;
    wire wb_ena_mem_out;
    
    MEM mem_unit(
        .clk(clk),
        .rst(rst),
        .start(mem_stall_ex_out),

        .ex_output(ex_output_ex_out),
        .rd_idx(rd_idx_ex_out),
        .op_type(op_type_ex_out),
        .rs1_val(rs1_val_ex_out),
        .rs2_val(rs2_val_ex_out),
        .imm(imm_ex_out),
        .csr_idx(csr_idx_ex_out),
        .alu_w_rd(alu_w_rd_ex_out),
        .mask(mask_ex_out),
        .store_ena(store_ena_ex_out),

        .rd_val(rd_val_mem_out),
        .rd_idx_out(rd_idx_out_mem_out),
        .op_type_out(op_type_out_mem_out),
        .rs1_val_out(rs1_val_out_mem_out),
        .imm_out(imm_out_mem_out),
        .csr_idx_out(csr_idx_out_mem_out),
        .wb_ena(wb_ena_mem_out)
        );
         
    
    WB wb_unit(
        .clk(clk),
        .rst(rst),
        .start(IF_start),
        
        .rd_val(rd_val_mem_out),
        .rd_idx(rd_idx_out_mem_out),
        .op_type(op_type_out_mem_out),
        .rs1_val(rs1_val_out_mem_out),
        .imm(imm_out_mem_out),
        .csr_idx(csr_idx_out_mem_out),
        .wb_ena(wb_ena_mem_out),
        .wb(wb_wb_out),
        .wbRd(wbRd_wb_out),
        .wbV(wbV_wb_out)
        );

    
    initial begin
        // IF input
        clk = 1'b0;
        rst = 1'b0;
        IF_start = 1'b1;
        PC_j = 1'b0;
        PC_branch = 32'd0;   
    end
    
    always #50 clk = ~clk;
    
endmodule
