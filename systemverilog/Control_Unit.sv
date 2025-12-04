module control_unit (
    input  logic        clk, reset,
    input  logic [3:0]  opcode,
    output logic        pc_write,
    output logic        mem_read,
    output logic        mem_write,
    output logic        ir_write,
    output logic        ac_write,
    output logic        b_write,
    output logic        o_write,
    output logic [2:0]  alu_control,
    output logic [1:0]  state
);
    
    logic [1:0] current_state, next_state;
    
    localparam S0 = 2'b00;  // Fetch
    localparam S1 = 2'b01;  // Decode  
    localparam S2 = 2'b10;  // Execute
    localparam S3 = 2'b11;  // Writeback
    
    // State register
    always_ff @(posedge clk or posedge reset) begin
        if (reset)
            current_state <= S0;
        else
            current_state <= next_state;
    end
    
    // Next state logic - FIXED HLT behavior
    always_comb begin
        if (opcode == 4'b1111) begin // HALT - stay in current state
            next_state = current_state;
        end else begin
            case (current_state)
                S0: next_state = S1;
                S1: next_state = S2;
                S2: begin
                    if (opcode inside {4'b0000, 4'b0001, 4'b0010, 4'b0011, 4'b1100})
                        next_state = S3;
                    else
                        next_state = S0;
                end
                S3: next_state = S0;
                default: next_state = S0;
            endcase
        end
    end
    
    // Output logic
    always_comb begin
        // Defaults
        pc_write = 1'b0; mem_read = 1'b0; mem_write = 1'b0; ir_write = 1'b0;
        ac_write = 1'b0; b_write = 1'b0; o_write = 1'b0; alu_control = 3'b000;
        
        if (opcode == 4'b1111) begin // HALT - disable all
            // No operations
        end else begin
            case (current_state)
                S0: begin // Fetch
                    mem_read = 1'b1;
                    ir_write = 1'b1;
                end
                
                S1: begin // Decode
                    pc_write = 1'b1;
                    if (opcode inside {4'b1100, 4'b1101, 4'b1110})
                        b_write = 1'b1; // Load address into B
                end
                
                S2: begin // Execute
                    case (opcode)
                        4'b1100: begin // LDA
                            mem_read = 1'b1; // Read from data address
                        end
                        4'b1101: begin // LDB  
                            mem_read = 1'b1; // Read from data address
                            b_write = 1'b1;  // Write to B register
                        end
                        4'b1110: mem_write = 1'b1; // STR
                        4'b0000: alu_control = 3'b000; // ADD
                        4'b0001: alu_control = 3'b001; // SUB
                        4'b0010: alu_control = 3'b010; // OR
                        4'b0011: alu_control = 3'b011; // AND
                        4'b1010: o_write = 1'b1;       // OUT
                        default: ; // NOP
                    endcase
                end
                
                S3: begin // Writeback
                    if (opcode inside {4'b0000, 4'b0001, 4'b0010, 4'b0011, 4'b1100})
                        ac_write = 1'b1;
                end
            endcase
        end
    end
    
    assign state = current_state;
    
endmodule
