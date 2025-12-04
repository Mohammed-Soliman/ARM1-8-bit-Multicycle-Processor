module alu (
    input  logic [7:0]  a, b,
    input  logic [2:0]  alu_control,
    output logic [7:0]  result,
    output logic        zero_flag,
    output logic        carry_flag,
    output logic        negative_flag,
    output logic        overflow_flag
);
    
    logic [8:0] extended_result;
    
    always_comb begin
        case (alu_control)
            3'b000: begin                  // ADD
                extended_result = a + b;
                result = extended_result[7:0];
            end
            3'b001: begin                  // SUB
                extended_result = a - b;
                result = extended_result[7:0];
            end
            3'b010: result = a | b;        // OR
            3'b011: result = a & b;        // AND
            default: result = a;           // Pass through
        endcase
        
        // Flags
        zero_flag = (result == 8'h00);
        carry_flag = extended_result[8];
        negative_flag = result[7];
        overflow_flag = (a[7] & b[7] & ~result[7]) | (~a[7] & ~b[7] & result[7]);
    end
    
endmodule
