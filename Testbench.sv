module arm1_tb;
    
    // Clock and reset
    logic clk, reset;
    
    // Instantiate the processor
    arm1_top processor (.clk(clk), .reset(reset));
    
    // Clock generation
    initial begin
        clk = 0;
        forever #10 clk = ~clk;
    end
    
    // Test sequence
    initial begin
        // Initialize
        reset = 1;
        $display("=== ARM1 Processor Testbench ===");
        $display("Time: %0t | Initializing with reset...", $time);
        
        // Release reset
        #25;
        reset = 0;
        $display("Time: %0t | Reset released", $time);
        $display("");
        
        // Run for enough cycles
        #1000;
        
        // Final results
        $display("");
        $display("=== Final Results ===");
        $display("AC: %h (%0d)", processor.processor.AC.ac_out, processor.processor.AC.ac_out);
        $display("B:  %h (%0d)", processor.processor.B.b_out, processor.processor.B.b_out);
        $display("O:  %h (%0d)", processor.processor.O.o_out, processor.processor.O.o_out);
        $display("Memory[14]: %h (%0d)", processor.processor.MEM.mem[14], processor.processor.MEM.mem[14]);
        
        $finish;
    end
    
    // Monitor
    initial begin
        $display("Time | State | PC | Opcode | Addr | AC   | B    | O    | Operation");
        $display("-------------------------------------------------------------------");
        forever begin
            @(posedge clk);
            #1;
            if (!reset) begin
                $write("%4t | %s | %2h | %s | %h   ", 
                    $time,
                    get_state_name(processor.processor.CTRL.state),
                    processor.processor.PC.pc_value,
                    get_opcode_name(processor.processor.IR.opcode),
                    processor.processor.IR.address_field
                );
                
                case (processor.processor.CTRL.state)
                    2'b00: $display("| -- | -- | -- | Fetch");
                    2'b01: $display("| -- | -- | -- | Decode");
                    2'b10, 2'b11: $display("| %2h | %2h | %2h | %s", 
                        processor.processor.AC.ac_out,
                        processor.processor.B.b_out,
                        processor.processor.O.o_out,
                        get_operation(processor.processor.IR.opcode)
                    );
                endcase
            end
        end
    end
    
    function string get_state_name(logic [1:0] state);
        case(state)
            2'b00: return "S0  ";
            2'b01: return "S1  ";
            2'b10: return "S2  ";
            2'b11: return "S3  ";
            default: return "UNKN";
        endcase
    endfunction
    
    function string get_opcode_name(logic [3:0] opcode);
        case(opcode)
            4'b1100: return "LDA ";
            4'b1101: return "LDB ";
            4'b1110: return "STR ";
            4'b1111: return "HLT ";
            4'b0000: return "ADD ";
            4'b0001: return "SUB ";
            4'b0010: return "OR  ";
            4'b0011: return "AND ";
            4'b1010: return "OUT ";
            default: return "NOP ";
        endcase
    endfunction
    
    function string get_operation(logic [3:0] opcode);
        case(opcode)
            4'b1100: return "Load AC";
            4'b1101: return "Load B ";
            4'b1110: return "Store  ";
            4'b0000: return "Add    ";
            4'b0001: return "Subtract";
            4'b0010: return "OR     ";
            4'b0011: return "AND    ";
            4'b1010: return "Output ";
            default: return "NOP    ";
        endcase
    endfunction
    
endmodule