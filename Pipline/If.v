module IF(
    input                   clk,
    input                   rst,
    input                   start,
    input       [31:0]      PC,
    input                   PC_jump,
    output                  PC_plus4,
    output      [31:0]      NPC,
    output      [31:0]      inst
);

wire    [31:0]      inst_addr;
reg     [31:0]      PC_branch;

// fetch Instruction
always @(posedge clk) begin
    if(rst)
        inst_addr[31:0] <= 32'd0;
    else 
        inst_addr[31:0] <= PC[31:0];
        inst[31:0] <= 
end

// PC + 4
always @(posedge clk) begin
    if(rst)
        PC_plus4[31:0] <= PC[31:0];
    else 
        PC_plus4[31:0] <= PC[31:0] + 3'b100;
end

// next PC
always @(posedge clk) begin
    if(rst)
        NPC[31:0] <= PC[31:0];
    else begin
        if(PC_jump) 
            NPC[31:0] <= PC_branch[31:0];
        else
            NPC[31:0] <= PC_plus4[31:0];
    end
end


endmodule