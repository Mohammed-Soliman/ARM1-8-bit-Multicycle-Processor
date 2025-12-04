module memory (
    input  logic        clk,
    input  logic        mem_write,
    input  logic        mem_read, 
    input  logic [3:0]  address,
    input  logic [7:0]  write_data,
    output logic [7:0]  read_data
);
    
    logic [7:0] mem [0:15];
    
    // Initialize memory - SIMPLIFIED
    initial begin
        // Program
        mem[0] = 8'hCC;  // LDA 12
        mem[1] = 8'hDD;  // LDB 13
        mem[2] = 8'h00;  // ADD
        mem[3] = 8'h20;  // OR  
        mem[4] = 8'hEE;  // STR 14
        mem[5] = 8'hA0;  // OUT
        mem[6] = 8'hF0;  // HLT
        
        // Fill unused
        mem[7] = 8'h00; mem[8] = 8'h00; mem[9] = 8'h00;
        mem[10] = 8'h00; mem[11] = 8'h00;
        
        // Data
        mem[12] = 8'h05;  // Data 5
        mem[13] = 8'h03;  // Data 3
        mem[14] = 8'h00;  // Result
        mem[15] = 8'h00;
    end
    
    // SIMPLE COMBINATORIAL READ - Always output data
    assign read_data = mem[address];
    
    // Synchronous write
    always @(posedge clk) begin
        if (mem_write) begin
            mem[address] <= write_data;
        end
    end
    
endmodule